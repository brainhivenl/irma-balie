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

	// "encoding/json"

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
	if state.ScannedCard == nil {
		return "", errors.New("No scanned card was set in state")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 3000*time.Millisecond)
	defer cancel()

	cmdParts := strings.Split(cfg.MrtdUnpack, " ")
	cmd := exec.CommandContext(ctx, cmdParts[0], cmdParts[1:]...)
	cmd.Stdin = strings.NewReader(*state.ScannedCard)

	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()

	if err != nil {
		return "", err
	}

	return out.String(), nil
}

func (app App) handleCreate(w http.ResponseWriter, r *http.Request) {
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
		w.WriteHeader(503)
		io.WriteString(w, "503 upstream problem")
		return
	}

	// Commit to new state
	app.State = state
	io.WriteString(w, token.Claims.(*ChallengeClaims).Challenge)
}

func (app App) handleScanned(w http.ResponseWriter, r *http.Request) {
	bodyBytes, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Fatal(err)
	}
	bodyString := string(bodyBytes)

	state := app.State
	state.ScannedCard = &bodyString

	unpacked, err := state.unpackMrtd(app.Cfg)
	if err != nil {
		log.Println(fmt.Sprintf("failed to parse scanned: %v", err))
		w.WriteHeader(400)
		io.WriteString(w, "400 bad request")
		return
	}

	// Commit to new state
	app.State = state

	// TODO send state via websocket
	log.Println(fmt.Sprintf("TODO to websocket %s", unpacked))

	io.WriteString(w, "ok")
}
