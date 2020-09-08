#!/usr/bin/env bash
BALIE_SERVER_DEBUGMODE=true \
BALIE_SERVER_IRMASERVER=foo \
BALIE_SERVER_JWTSECRET=foo \
BALIE_SERVER_MRTDUNPACK="../mrtd-unpack/run.dev.sh" \
go run .
