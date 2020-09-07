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

type State struct {
	Challenge string
}

type Configuration struct {
	ListenAddress   string
	FrontendAddress string
	ServerAddress   string
	State           *State
}

type App struct {
	Cfg Configuration
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

	app := App{Cfg: cfg}

	externalMux := http.NewServeMux()
	// externalMux.HandleFunc("/", app.handleStatus)
	externalMux.HandleFunc("/create", app.handleCreate)

	externalServer := http.Server{
		Addr:    cfg.ListenAddress,
		Handler: externalMux,
	}
	log.Printf("Starting external HTTP server on %v", cfg.ListenAddress)
	log.Fatal(externalServer.ListenAndServe())
}
