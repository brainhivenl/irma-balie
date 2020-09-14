package main

import (
	"encoding/json"
	"log"
)

type MessageType string

const (
	// NFCDetect signifies that we have detected an NFC client, hinting on user interaction with the kiosk.
	NFCDetect MessageType = "nfc-detect"

	// Created signifies that a session was created, hinting that the OCR process has completed successfully.
	Created = "created"

	// Scanned signifies that a document was scanned successfully, and contains the unpacked MRTD to be displayed.
	Scanned = "scanned"

	// TerminateBus signifies that the socket should stop listening.
	TerminateBus = "terminate-bus"
)

// Message is a short string passed through the messageBus to all listening frontends
type Message struct {
	Type  MessageType     `json:"type"`
	Value json.RawMessage `json:"value"`
}

type subscription struct {
	listener chan<- Message
}

// Broadcaster is a service that passes messages through a messageBus to all listening websockets
type Broadcaster struct {
	registerOps   chan subscription
	unregisterOps chan subscription
	messageBus    chan Message
}

func makeBroadcaster() Broadcaster {
	registerOps := make(chan subscription, 3)
	unregisterOps := make(chan subscription, 3)
	messageBus := make(chan Message, 1)
	return Broadcaster{registerOps, unregisterOps, messageBus}
}

// Subscribe schedules the registering of a listener
func (b Broadcaster) Subscribe(ch chan<- Message) {
	b.registerOps <- subscription{ch}
}

// Unsubscribe schedules the unregistering of a listener
func (b Broadcaster) Unsubscribe(ch chan<- Message) {
	b.unregisterOps <- subscription{ch}
}

// Notify sends a message through the messageBus to all listening websockets
func (b Broadcaster) Notify(msg Message) {
	b.messageBus <- msg
}

func notifyDaemon(app App) {
	log.Printf("Starting notifyDaemon")

	channels := make([]chan<- Message, 0)
	for {
		select {
		case msg := <-app.Broadcaster.messageBus:
			for _, l := range channels {
				if l != nil {
					l <- msg
				}
			}

		case op := <-app.Broadcaster.registerOps:
			log.Printf("Registered channel")
			channels = append(channels, op.listener)

		case op := <-app.Broadcaster.unregisterOps:
			log.Printf("Unregistered channel")
			op.listener <- Message{Type: TerminateBus}
			subscribers := channels
			for i, l := range subscribers {
				if l == op.listener {
					subscribers[i] = subscribers[len(subscribers)-1]
					subscribers = subscribers[:len(subscribers)-1]
					channels = subscribers
					break
				}
			}
		}
	}
}
