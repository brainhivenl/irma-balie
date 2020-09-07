package main

import (
	"bytes"
	"context"
	"errors"
	"io"
	"log"
	"os/exec"
	"strings"
	"time"

	"encoding/json"

	"fmt"
	"net/http"

	"io/ioutil"

	jwt "github.com/dgrijalva/jwt-go"
)

// ChallengeClaims is a Challenge in the JWT claims-sense.
// Acts as a challenge-response mechanism as the challenge will be signed by the MRTD using Active Authentication (AA).
// Original signed JWT should be resent to the server.
type ChallengeClaims struct {
	Challenge string `json:"challenge"`
	jwt.StandardClaims
}

// MrtdPrototype is the set of fields in the Mrtd response which are of interest for the client.
// We require the challenge to check whether it corresponds to our current state.
type MrtdPrototype struct {
	Challenge string `json:"challenge"`
}

// UnpackedPrototype is the set of fields in the unpacked Mrtd which are of interest to the client.
// We require valid to check whether the Mrtd itself is valid.
type UnpackedPrototype struct {
	Valid          bool   `json:"valid"`
	DocumentNumber string `json:"document_number"`
}

// IssuanceRequest is a request to the balie server for an issuance.
type IssuanceRequest struct {
	Challenge string          `json:"challenge"`
	Document  json.RawMessage `json:"document"`
}

func (state State) parseChallenge() (*jwt.Token, error) {
	if state.Challenge == nil {
		return nil, errors.New("No challenge was set in state")
	}

	challenge := *state.Challenge

	parser := jwt.Parser{}
	// We do not need to verify the claim; we will pass the original JWT back to the server.
	token, _, err := parser.ParseUnverified(challenge, &ChallengeClaims{})
	return token, err
}

func (state State) unpackMrtd(cfg Configuration) (string, error) {
	if state.ScannedDocument == nil {
		return "", errors.New("No scanned document was set in state")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 3000*time.Millisecond)
	defer cancel()

	cmdParts := strings.Split(cfg.MrtdUnpack, " ")
	cmd := exec.CommandContext(ctx, cmdParts[0], cmdParts[1:]...)
	cmd.Stdin = strings.NewReader(*state.ScannedDocument)

	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()

	if err != nil {
		return "", err
	}

	return out.String(), nil
}

func (app *App) handleCreate(w http.ResponseWriter, r *http.Request) {
	resp, err := http.Get(fmt.Sprintf("%s/create", app.Cfg.ServerAddress))
	if err != nil {
		log.Println(fmt.Sprintf("failed to create new session: %v", err))
		w.WriteHeader(503)
		io.WriteString(w, "503 upstream problem")
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
		log.Println(fmt.Sprintf("server response invalid: %v", err))
		http.Error(w, "503 upstream problem", http.StatusServiceUnavailable)
		return
	}

	// Commit to new state
	app.State = state
	io.WriteString(w, token.Claims.(*ChallengeClaims).Challenge)
}

func (app *App) handleScanned(w http.ResponseWriter, r *http.Request) {
	if app.State.Challenge == nil {
		w.WriteHeader(400)
		io.WriteString(w, "400 state challenge unset")
		return
	}

	bodyBytes, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Fatal(err)
	}
	bodyString := string(bodyBytes)

	state := app.State
	state.ScannedDocument = &bodyString

	mrtdPrototype := MrtdPrototype{}
	err = json.Unmarshal(bodyBytes, &mrtdPrototype)
	if err != nil {
		log.Println(fmt.Sprintf("failed to unmarshall: %s", err))
		w.WriteHeader(400)
		io.WriteString(w, "400 failed to unmarshall")
		return
	}

	token, err := state.parseChallenge()
	if err != nil {
		log.Fatal(fmt.Sprintf("current state invalid: %v", err))
		w.WriteHeader(501)
		io.WriteString(w, "501 logic error")
		return
	}

	if token.Claims.(*ChallengeClaims).Challenge != mrtdPrototype.Challenge {
		if app.Cfg.DebugMode {
			log.Println("WARNING: challenge does not match, but disregarding due to debug mode")
		} else {
			w.WriteHeader(400)
			io.WriteString(w, "400 inconsistent challenge")
			return
		}
	}

	unpacked, err := state.unpackMrtd(app.Cfg)
	if err != nil {
		log.Printf("failed to parse scanned: %v", err)
		http.Error(w, "400 bad request", http.StatusBadRequest)
		return
	}

	unpackedPrototype := UnpackedPrototype{}
	err = json.Unmarshal([]byte(unpacked), &unpackedPrototype)
	if err != nil {
		log.Println(fmt.Sprintf("failed to unmarshall: %s", err))
		w.WriteHeader(400)
		io.WriteString(w, "400 failed to unmarshall")
		return
	}

	if !unpackedPrototype.Valid {
		if app.Cfg.DebugMode {
			log.Println("WARNING: scanned document is not valid, but disregarding due to debug mode")
		} else {
			w.WriteHeader(400)
			io.WriteString(w, "400 invalid document")
			return
		}
	}

	// Commit to new state
	app.State = state

	// TODO send state via websocket
	log.Println(fmt.Sprintf("Stored document for %s", unpackedPrototype.DocumentNumber))

	io.WriteString(w, "ok")
}

func (app *App) handleSubmit(w http.ResponseWriter, r *http.Request) {
	state := app.State
	if state.Challenge == nil || state.ScannedDocument == nil {
		w.WriteHeader(400)
		io.WriteString(w, "400 state unset")
		return
	}

	request := IssuanceRequest{
		Challenge: *app.State.Challenge,
		Document:  []byte(*app.State.ScannedDocument),
	}

	marshalledRequest, err := json.Marshal(request)
	if err != nil {
		log.Println(fmt.Sprintf("failed to marshall: %s", err))
		w.WriteHeader(500)
		io.WriteString(w, "500 failed to marshall")
		return
	}

	resp, err := http.Post(fmt.Sprintf("%s/submit", app.Cfg.ServerAddress), "application/json", bytes.NewBuffer(marshalledRequest))
	if err != nil || resp.StatusCode != 200 {
		log.Println(fmt.Sprintf("failed to submit for session: %d %v", resp.StatusCode, err))
		w.WriteHeader(503)
		io.WriteString(w, "503 upstream problem")
		return
	}

	io.WriteString(w, "ok")
}
