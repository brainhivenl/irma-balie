#!/usr/bin/env bash

export BALIE_CLIENT_MRTDUNPACK=`pwd`/dist/mrtdunpack/bin/mrtdunpack
export BALIE_CLIENT_SERVERADDRESS=http://localhost:8081
export BALIE_SERVER_IRMASERVER=http://localhost:8088
export BALIE_SERVER_JWTSECRET=foo
export BALIE_SERVER_MRTDUNPACK=`pwd`/dist/mrtdunpack/bin/mrtdunpack
export BALIE_SERVER_PASSPORTCREDENTIALID="tweedegolf-demo.amsterdam.passport"
export BALIE_SERVER_IDCARDCREDENTIALID="tweedegolf-demo.amsterdam.idcard"
export MRTDSCANNER_CLIENTHOST=http://localhost:8080
export BALIE_SERVER_DEBUGMODE="true"
export BALIE_CLIENT_DEBUGMODE="true"
