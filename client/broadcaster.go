package main

import (
	"encoding/json"
	"log"
)

type MessageType string

const (
	NFCDetect MessageType = "nfc-detect"
	Created               = "created"
	Scanned               = "scanned"
)

// Message is a short string passed through the messageBus to all listening frontends
type Message struct {
	Type  MessageType
	Value json.RawMessage
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
	registerOps := make(chan subscription, 10)
	unregisterOps := make(chan subscription, 10)
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

	channels := make([]chan<- Message, 10)
	for {
		select {
		case msg := <-app.Broadcaster.messageBus:
			for _, l := range channels {
				l <- msg
			}

		case op := <-app.Broadcaster.registerOps:
			channels = append(channels, op.listener)

		case op := <-app.Broadcaster.unregisterOps:
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
