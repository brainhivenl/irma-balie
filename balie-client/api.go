package main

import (
	"io"
	"log"

	// "encoding/json"

	"fmt"
	"net/http"

	// irma "github.com/privacybydesign/irmago"
	// "github.com/privacybydesign/irmago/server"

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

	parser := jwt.Parser{}
	// We do not need to verify the claim; we will pass the original JWT back to the server.
	token, _, err := parser.ParseUnverified(bodyString, &ChallengeClaims{})
	if err != nil {
		log.Println(fmt.Sprintf("server response invalid: %v", err))
		w.WriteHeader(503)
		io.WriteString(w, "503 upstream problem")
		return
	}

	app.State.Challenge = &bodyString
	io.WriteString(w, token.Claims.(*ChallengeClaims).Challenge)
}
