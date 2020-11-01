package main

import (
	"time"
)

func statusPollerDaemon(app *App) {
	ticker := time.NewTicker(time.Second * 5)

	for range ticker.C {
		status := app.getStatus()

		if !status.IsOK() {
			app.Broadcaster.Notify(Message{
				Type: NotReady,
			})
		}
	}
}
