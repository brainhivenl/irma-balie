package main

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"time"

	// irma "github.com/privacybydesign/irmago"
	// "github.com/privacybydesign/irmago/server"

	jwt "github.com/dgrijalva/jwt-go"
	"github.com/tweedegolf/irma-balie/common"
)

func (app App) handleCreate(w http.ResponseWriter, r *http.Request) {
	challenge := make([]byte, 8)
	rand.Read(challenge)

	var duration, _ = time.ParseDuration("2m")
	if app.Cfg.DebugMode {
		// Support longer duration for debug mode.
		duration, _ = time.ParseDuration("2h")
	}
	challengeClaims := common.ChallengeClaims{
		Challenge: base64.StdEncoding.EncodeToString(challenge),
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Add(duration).Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, challengeClaims)

	response, err := token.SignedString([]byte(app.Cfg.JwtSecret))

	if err != nil {
		log.Printf("error signing challenge: %v", err)
		http.Error(w, "500 failed to sign challenge", http.StatusInternalServerError)
		return
	}
	io.WriteString(w, response)
}

func (app App) handleSubmit(w http.ResponseWriter, r *http.Request) {
	bodyBytes, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Fatal(err)
	}

	request := common.IssuanceRequest{}
	err = json.Unmarshal(bodyBytes, &request)
	if err != nil {
		http.Error(w, "400 failed to unmarshal", http.StatusBadRequest)
		return
	}

	challenge := common.ChallengeClaims{}
	_, err = jwt.ParseWithClaims(request.Challenge, &challenge, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
		}

		return []byte(app.Cfg.JwtSecret), nil
	})
	if err != nil {
		if verr, ok := err.(*jwt.ValidationError); ok && verr.Errors == jwt.ValidationErrorExpired {
			http.Error(w, "403 challenge expired", http.StatusForbidden)
		} else {
			http.Error(w, "403 challenge not valid", http.StatusForbidden)
		}
		return
	}

	mrtdRequest := common.MrtdRequest{
		Challenge:  challenge.Challenge,
		RawMessage: request.Document,
	}

	unpacked, err := common.UnpackMrtd(app.Cfg.MrtdUnpack, mrtdRequest)
	if err != nil {
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

	// TODO check document expiry in unpackedPrototype.DateOfExpiry.

	// TODO create IRMA issuance for this prototype.
	log.Printf("TODO %v", unpackedPrototype)

	io.WriteString(w, "ok")
}
