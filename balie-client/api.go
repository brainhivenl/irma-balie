package main

import (
	"io"
	"log"

	// "encoding/json"

	"fmt"
	"net/http"

	// irma "github.com/privacybydesign/irmago"
	// "github.com/privacybydesign/irmago/server"

	jwt "github.com/dgrijalva/jwt-go"
)

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

	token, err := jwt.Parse(resp.Body);
	// challenge := make([]byte, 8)
	// rand.Read(challenge)

	// duration, err := time.ParseDuration("2m")
	// challengeClaims := ChallengeClaims{
	// 	Challenge: base64.StdEncoding.EncodeToString(challenge),
	// 	StandardClaims: jwt.StandardClaims{
	// 		ExpiresAt: time.Now().Add(duration).Unix(),
	// 	},
	// }

	// token := jwt.NewWithClaims(jwt.SigningMethodHS256, challengeClaims)

	// response, err := token.SignedString([]byte(app.Cfg.JwtSecret))

	// if err != nil {
	// 	panic(fmt.Sprintf("error signing challenge: %v", err))
	// }
	// io.WriteString(w, resp)
}
