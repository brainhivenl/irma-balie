package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/kelseyhightower/envconfig"
	"github.com/tweedegolf/irma-balie/common"
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
	exit := make(chan os.Signal, 1)
	signal.Notify(exit, os.Interrupt, syscall.SIGINT, syscall.SIGTERM)

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

	if _, err := common.TestMrtd(cfg.MrtdUnpack); err != nil {
		log.Fatalf("Failed to run dry-run mrtd-unpack: %v", err)
		return
	}
	log.Println("Mrtd-unpack functionality verified")

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

	go func() {
		err := externalServer.ListenAndServe()
		log.Printf("listen and serve returned")
		if err != nil && err != http.ErrServerClosed {
			log.Fatal(err)
		}
	}()

	<-exit
	log.Printf("received exit signal")
	externalServer.Shutdown(context.Background())
}
