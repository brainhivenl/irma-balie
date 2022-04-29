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

	challenge := common.ChallengeClaims{}
	parser := jwt.Parser{}
	// We do not need to verify the claim; we will pass the original JWT back to the server.
	_, _, err := parser.ParseUnverified(*state.Challenge, &challenge)

	if err != nil {
		return "", err
	}

	request := common.MrtdRequest{
		Challenge: challenge.Challenge,
		Document:  []byte(*state.ScannedDocument),
	}

	return common.UnpackMrtd(cfg.MrtdUnpack, request)
}

func (app *App) handleDetected(w http.ResponseWriter, r *http.Request) {
	app.Broadcaster.Notify(Message{
		Type: NFCDetect,
	})

	io.WriteString(w, "ok")
}

func (app *App) handleReinsert(w http.ResponseWriter, r *http.Request) {
	app.Broadcaster.Notify(Message{
		Type: Reinsert,
	})

	io.WriteString(w, "ok")
}

func (app *App) handleCreate(w http.ResponseWriter, r *http.Request) {
	if !app.getStatus().IsOK() {
		http.Error(w, "425 not ready", http.StatusTooEarly)
		return
	}

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
		log.Printf("state challenge unset")
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
		log.Printf("unmarshall failed %v", err)
		http.Error(w, "400 failed to unmarshall", http.StatusBadRequest)
		return
	}

	if !unpackedPrototype.Valid {
		if app.Cfg.DebugMode {
			log.Println("WARNING: scanned document is not valid, but disregarding due to debug mode")
		} else {
			log.Println("scanned document is not valid")
			http.Error(w, "400 invalid document", http.StatusBadRequest)
			return
		}
	}

	attributes, err := unpackedPrototype.ToCredentialAttributes(time.Now())
	if err != nil {
		log.Println("failed to convert to attributes")
		http.Error(w, "500 failed to convert to attributes", http.StatusInternalServerError)
		return
	}

	attributesBytes, err := json.Marshal(attributes)
	if err != nil {
		http.Error(w, "500 failed to marshall", http.StatusInternalServerError)
		return
	}

	// Commit to new state
	app.State = state

	// Send scanned document over websockets
	go app.Broadcaster.Notify(Message{
		Type:  Scanned,
		Value: attributesBytes,
	})

	log.Println(fmt.Sprintf("Stored document for %s", unpackedPrototype.DocumentNumber))

	io.WriteString(w, "ok")
}

func (app *App) handleSubmit(w http.ResponseWriter, r *http.Request) {
	state := app.State
	if state.Challenge == nil || state.ScannedDocument == nil {
		log.Printf("missing state")
		http.Error(w, "400 missing state", http.StatusBadRequest)
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
		log.Printf("failed to submit: %s", err)
		http.Error(w, "503 upstream problem", http.StatusServiceUnavailable)
		return
	}
	bodyBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Printf("failed to read response body: %s", err)
		http.Error(w, "503 upstream problem", http.StatusServiceUnavailable)
		return
	}
	if resp.StatusCode != 200 {
		log.Printf("received non-200 response from server (%s): %s", resp.Status, string(bodyBytes))
		http.Error(w, string(bodyBytes), http.StatusServiceUnavailable)
		return
	}

	sessionJwt := string(bodyBytes)
	app.State.SessionJwt = &sessionJwt

	parser := jwt.Parser{}
	// We do not need to verify the claim; we will pass the original JWT back to the server.
	issuanceSession, _, err := parser.ParseUnverified(sessionJwt, &common.IssuanceClaims{})
	if err != nil {
		log.Printf("failed to parse issuanceSession JWT: %s", err)
		http.Error(w, "500 failed to parse issuance session", http.StatusInternalServerError)
		return
	}

	app.Broadcaster.Notify(Message{
		Type: Submitted,
	})

	io.WriteString(w, string(issuanceSession.Claims.(*common.IssuanceClaims).SessionPtr))
	log.Printf("Successfully handled submit request")
}

func (app App) getUpstreamStatus() bool {
	resp, err := http.Get(fmt.Sprintf("%s/status", app.Cfg.ServerAddress))

	return err == nil && resp.StatusCode == 200
}

func (app App) getClockStatus() bool {
	return time.Now().After(time.Date(2000, time.January, 0, 0, 0, 0, 0, time.UTC))
}

func (app App) getStatus() common.StatusResponse {
	return common.StatusResponse{
		Upstream: app.getUpstreamStatus(),
		Clock:    app.getClockStatus(),
	}
}

func (app App) handleStatus(w http.ResponseWriter, r *http.Request) {
	response := app.getStatus()
	responseJSON, err := json.Marshal(response)

	if err != nil {
		http.Error(w, "500 marshal failed", http.StatusInternalServerError)
		return
	}

	if !response.IsOK() {
		w.WriteHeader(http.StatusTooEarly)
	}

	w.Write(responseJSON)
}

func (app App) handleSocket(w http.ResponseWriter, r *http.Request) {
	ws, err := upgrader.Upgrade(w, r, nil)
	defer func() {
		ws.Close()
	}()
	if err != nil {
		log.Println("failed to upgrade session status connection:", err)
		return
	}

	if !app.getStatus().IsOK() {
		_ = ws.WriteJSON(Message{
			NotReady,
			nil,
		})
		return
	}

	// send this websocket a message that we have established a connection
	err = ws.WriteJSON(Message{
		Connected,
		nil,
	})
	if err != nil {
		log.Println("failed to send connected message", err)
		return
	}

	msgPipe := make(chan Message, 2)
	app.Broadcaster.Subscribe(msgPipe)
	defer app.Broadcaster.Unsubscribe(msgPipe)

	waitDuration := 100 * time.Millisecond
	ticker := time.NewTicker(waitDuration)
	defer func() {
		ticker.Stop()
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

			if msg.Type == NotReady {
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
