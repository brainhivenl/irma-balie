package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"time"
)

func irmaPollerDaemon(app *App) {
	ticker := time.NewTicker(time.Second)

	for range ticker.C {
		if app.State.SessionJwt == nil {
			continue
		}

		sessionJwt := *app.State.SessionJwt

		resp, err := http.Post(fmt.Sprintf("%s/session", app.Cfg.ServerAddress), "application/jsonwebtoken", bytes.NewBuffer([]byte(sessionJwt)))
		if err != nil || resp.StatusCode != 200 {
			log.Printf("Failed to contact upstream server in irmaPoller: %v / %v", err, resp.StatusCode)
			continue
		}

		bodyBytes, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			log.Printf("Failed to read bytes in irmaPoller: %v", err)
			continue
		}
		status := string(bodyBytes)

		messageValue := map[string]string{
			"status": status,
		}

		messageValueMarshalled, err := json.Marshal(messageValue)
		if err != nil {
			log.Printf("Failed to marhal in irmaPoller: %v", err)
			continue
		}

		app.Broadcaster.Notify(Message{
			Type:  IrmaInProgress,
			Value: messageValueMarshalled,
		})

		if irmaStatusIsFinal(status) {
			app.State = State{}
		}
	}
}

func irmaStatusIsFinal(status string) bool {
	return status != "" && status != "INITIALIZED" && status != "CONNECTED"
}
