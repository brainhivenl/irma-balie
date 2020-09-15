package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"time"

	jwt "github.com/dgrijalva/jwt-go"

	"github.com/gorilla/websocket"
	"github.com/tweedegolf/irma-balie/common"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	// Accept any origin
	CheckOrigin: func(r *http.Request) bool { return true },
}

func (state State) parseChallenge() (*jwt.Token, error) {
	if state.Challenge == nil {
		return nil, errors.New("No challenge was set in state")
	}

	challenge := *state.Challenge

	parser := jwt.Parser{}
	// We do not need to verify the claim; we will pass the original JWT back to the server.
	token, _, err := parser.ParseUnverified(challenge, &common.ChallengeClaims{})
	return token, err
}

func (state State) unpackMrtd(cfg Configuration) (string, error) {
	if state.Challenge == nil || state.ScannedDocument == nil {
		return "", errors.New("No scanned document or challenge was set in state")
	}

	request := common.MrtdRequest{
		Challenge:  *state.Challenge,
		RawMessage: []byte(*state.ScannedDocument),
	}

	return common.UnpackMrtd(cfg.MrtdUnpack, request)
}

func (app *App) handleDetected(w http.ResponseWriter, r *http.Request) {
	app.Broadcaster.Notify(Message{
		Type: NFCDetect,
	})

	io.WriteString(w, "ok")
}

func (app *App) handleCreate(w http.ResponseWriter, r *http.Request) {
	resp, err := http.Get(fmt.Sprintf("%s/create", app.Cfg.ServerAddress))
	if err != nil {
		log.Printf("failed to create new session: %v", err)
		http.Error(w, "503 upstream problem", http.StatusServiceUnavailable)
		return
	}

	bodyBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}
	bodyString := string(bodyBytes)

	state := State{}
	state.Challenge = &bodyString
	token, err := state.parseChallenge()

	if err != nil {
		log.Printf("server response invalid: %v", err)
		http.Error(w, "503 upstream problem", http.StatusServiceUnavailable)
		return
	}

	app.Broadcaster.Notify(Message{
		Type: Created,
	})

	// Commit to new state
	app.State = state
	io.WriteString(w, token.Claims.(*common.ChallengeClaims).Challenge)
}

func (app *App) handleScanned(w http.ResponseWriter, r *http.Request) {
	if app.State.Challenge == nil {
		http.Error(w, "400 state challenge unset", http.StatusBadRequest)
		return
	}

	bodyBytes, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Fatal(err)
	}
	bodyString := string(bodyBytes)

	state := app.State
	state.ScannedDocument = &bodyString

	unpacked, err := state.unpackMrtd(app.Cfg)
	if err != nil {
		log.Printf("unpack failed %v", err)
		http.Error(w, "400 unpack failed", http.StatusBadRequest)
		return
	}

	unpackedPrototype := common.UnpackedPrototype{}
	err = json.Unmarshal([]byte(unpacked), &unpackedPrototype)
	if err != nil {
		http.Error(w, "400 failed to unmarshall", http.StatusBadRequest)
		return
	}

	if !unpackedPrototype.Valid {
		if app.Cfg.DebugMode {
			log.Println("WARNING: scanned document is not valid, but disregarding due to debug mode")
		} else {
			http.Error(w, "400 invalid document", http.StatusBadRequest)
			return
		}
	}

	// Commit to new state
	app.State = state

	// Send scanned document over websockets
	app.Broadcaster.Notify(Message{
		Type:  Scanned,
		Value: []byte(unpacked),
	})

	log.Println(fmt.Sprintf("Stored document for %s", unpackedPrototype.DocumentNumber))

	io.WriteString(w, "ok")
}

func (app *App) handleSubmit(w http.ResponseWriter, r *http.Request) {
	state := app.State
	if state.Challenge == nil || state.ScannedDocument == nil {
		http.Error(w, "400 state unset", http.StatusBadRequest)
		return
	}

	request := common.IssuanceRequest{
		Challenge: *app.State.Challenge,
		Document:  []byte(*app.State.ScannedDocument),
	}

	marshalledRequest, err := json.Marshal(request)
	if err != nil {
		log.Printf("failed to marshall: %s", err)
		http.Error(w, "500 failed to marshall", http.StatusInternalServerError)
		return
	}

	resp, err := http.Post(fmt.Sprintf("%s/submit", app.Cfg.ServerAddress), "application/json", bytes.NewBuffer(marshalledRequest))
	if err != nil {
		return
	}
	if resp.StatusCode != 200 {
		bodyBytes, err := ioutil.ReadAll(r.Body)
		if err == nil {
			http.Error(w, string(bodyBytes), http.StatusServiceUnavailable)
		} else {
			http.Error(w, "503 upstream problem", http.StatusServiceUnavailable)
		}
		return
	}

	io.WriteString(w, "ok")
}

func (app App) handleSocket(w http.ResponseWriter, r *http.Request) {
	msgPipe := make(chan Message, 2)

	app.Broadcaster.Subscribe(msgPipe)
	defer app.Broadcaster.Unsubscribe(msgPipe)

	ws, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("failed to upgrade session status connection:", err)
		return
	}

	waitDuration := 100 * time.Millisecond
	ticker := time.NewTicker(waitDuration)
	defer func() {
		ticker.Stop()
		ws.Close()
	}()

	for {
		select {
		case msg := <-msgPipe:
			if msg.Type == TerminateBus {
				return
			}

			if err := ws.WriteJSON(msg); err != nil {
				return
			}
		case <-ticker.C:
			ws.SetWriteDeadline(time.Now().Add(waitDuration))
			if err := ws.WriteMessage(websocket.PingMessage, []byte("keepalive")); err != nil {
				return
			}
		}
	}
}
