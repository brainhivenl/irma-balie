package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/kelseyhightower/envconfig"
)

type Configuration struct {
	ListenAddress string
	IrmaServer    string
	JwtSecret     string
	MrtdUnpack    string
	DebugMode     bool
}

type App struct {
	Cfg Configuration
}

func main() {
	var cfg Configuration
	err := envconfig.Process("BALIE_SERVER", &cfg)
	if err != nil {
		panic(fmt.Sprintf("could not parse environment: %v", err))
	}

	if cfg.ListenAddress == "" {
		cfg.ListenAddress = "0.0.0.0:8081"
	}
	if cfg.IrmaServer == "" {
		panic("option required: BALIE_SERVER_IRMASERVER")
	}
	if cfg.JwtSecret == "" {
		panic("option required: BALIE_SERVER_JWTSECRET")
	}

	app := App{Cfg: cfg}

	externalMux := http.NewServeMux()
	// externalMux.HandleFunc("/", app.handleStatus)
	externalMux.HandleFunc("/create", app.handleCreate)
	externalMux.HandleFunc("/submit", app.handleSubmit)

	externalServer := http.Server{
		Addr:    cfg.ListenAddress,
		Handler: externalMux,
	}
	log.Printf("Starting external HTTP server on %v", cfg.ListenAddress)
	log.Fatal(externalServer.ListenAndServe())
}
