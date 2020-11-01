#!/usr/bin/env bash
BALIE_SERVER_DEBUGMODE=true \
BALIE_SERVER_IRMASERVER=http://localhost:8088 \
BALIE_SERVER_JWTSECRET=foo \
BALIE_SERVER_MRTDUNPACK="../mrtd-unpack/run.dev.sh" \
BALIE_SERVER_PASSPORTCREDENTIALID="tweedegolf-demo.amsterdam.passport" \
BALIE_SERVER_IDCARDCREDENTIALID="tweedegolf-demo.amsterdam.idcard" \
go run .
