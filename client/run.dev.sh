#!/usr/bin/env bash
BALIE_CLIENT_DEBUGMODE=true \
BALIE_CLIENT_SERVERADDRESS=http://localhost:8081 \
BALIE_CLIENT_FRONTENDADDRESS=http://localhost:8082 \
BALIE_CLIENT_MRTDUNPACK="../mrtd-unpack/run.dev.sh" \
go run .
