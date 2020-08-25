package main

import (
	"io"
	// "encoding/json"
	"encoding/base64"
	"fmt"
	"math/rand"
	"net/http"
	"time"

	// irma "github.com/privacybydesign/irmago"
	// "github.com/privacybydesign/irmago/server"

	jwt "github.com/dgrijalva/jwt-go"
)

type ChallengeClaims struct {
	Challenge string `json:"challenge"`
	jwt.StandardClaims
}

func (app App) handleCreate(w http.ResponseWriter, r *http.Request) {
	challenge := make([]byte, 8)
	rand.Read(challenge)

	duration, err := time.ParseDuration("2m")
	challengeClaims := ChallengeClaims{
		Challenge: base64.StdEncoding.EncodeToString(challenge),
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Add(duration).Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, challengeClaims)

	response, err := token.SignedString([]byte(app.Cfg.JwtSecret))

	if err != nil {
		panic(fmt.Sprintf("error signing challenge: %v", err))
	}
	io.WriteString(w, response)
}
