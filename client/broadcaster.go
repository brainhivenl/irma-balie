package main

import (
	"encoding/json"
	"log"
)

type MessageType string

const (
	// NotReady indicates to the frontend that a websocket connection is established, but that other processes have not yet finished booting.
	NotReady = "not-ready"

	// Connected indicates to the frontend that a websocket connection is established.
	Connected = "connected"

	// NFCDetect signifies that we have detected an NFC client, hinting on user interaction with the kiosk.
	NFCDetect MessageType = "nfc-detect"

	// Reinsert indicates that the card should be re-inserted into the slot.
	Reinsert = "reinsert"

	// Created signifies that a session was created, hinting that the OCR process has completed successfully.
	Created = "created"

	// Scanned signifies that a document was scanned successfully, and contains the unpacked MRTD to be displayed.
	Scanned = "scanned"

	// Submitted signifies that a document has been submitted for issuance.
	Submitted = "submitted"

	// IrmaInProgress signifies that the IRMA Go daemon is processing your session. Includes the IRMA status in the body.
	IrmaInProgress = "irma-in-progress"

	// TerminateBus signifies that the socket should stop listening.
	TerminateBus = "terminate-bus"
)

// Message is a short string passed through the messageBus to all listening frontends
type Message struct {
	Type  MessageType     `json:"type"`
	Value json.RawMessage `json:"value,omitempty"`
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

func broadcasterDaemon(broadcaster Broadcaster) {
	log.Printf("Starting broadcasterDaemon")

	channels := make([]chan<- Message, 0)
	for {
		select {
		case msg := <-broadcaster.messageBus:
			for _, l := range channels {
				if l != nil {
					l <- msg
				}
			}

		case op := <-broadcaster.registerOps:
			log.Printf("Registered channel")
			channels = append(channels, op.listener)

		case op := <-broadcaster.unregisterOps:
			log.Printf("Unregistered channel")
			op.listener <- Message{Type: TerminateBus}
			for i, l := range channels {
				if l == op.listener {
					channels[i] = channels[len(channels)-1]
					channels = channels[:len(channels)-1]
					break
				}
			}
		}
	}
}
