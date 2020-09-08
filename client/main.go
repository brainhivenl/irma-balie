package main

import (
	// "encoding/json"
	"fmt"
	"log"
	"net/http"

	// "os"
	// "time"

	"github.com/kelseyhightower/envconfig"
)

type Configuration struct {
	ListenAddress   string
	FrontendAddress string
	ServerAddress   string
	MrtdUnpack      string
	DebugMode       bool
}

type State struct {
	Challenge       *string
	ScannedDocument *string
}

type App struct {
	Cfg   Configuration
	State State
}

func main() {
	var cfg Configuration
	err := envconfig.Process("BALIE_CLIENT", &cfg)
	if err != nil {
		panic(fmt.Sprintf("could not parse environment: %v", err))
	}

	if cfg.ListenAddress == "" {
		cfg.ListenAddress = "0.0.0.0:8080"
	}
	if cfg.FrontendAddress == "" {
		panic("option required: BALIE_CLIENT_FRONTENDADDRESS")
	}
	if cfg.ServerAddress == "" {
		panic("option required: BALIE_CLIENT_SERVERADDRESS")
	}
	if cfg.MrtdUnpack == "" {
		panic("option required: BALIE_CLIENT_MRTDUNPACK")
	}

	if cfg.DebugMode {
		log.Println("WARNING: debug mode enabled")
	} else {
		log.Println("Started in production mode")
	}

	state := State{Challenge: nil, ScannedDocument: nil}
	app := App{Cfg: cfg, State: state}

	externalMux := http.NewServeMux()
	// externalMux.HandleFunc("/", app.handleStatus)
	externalMux.HandleFunc("/create", app.handleCreate)
	externalMux.HandleFunc("/scanned", app.handleScanned)
	externalMux.HandleFunc("/submit", app.handleSubmit)

	externalServer := http.Server{
		Addr:    cfg.ListenAddress,
		Handler: externalMux,
	}
	log.Printf("Starting external HTTP server on %v", cfg.ListenAddress)
	log.Fatal(externalServer.ListenAndServe())
}
