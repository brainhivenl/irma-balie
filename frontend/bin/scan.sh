#!/usr/bin/env bash

curl -i -k -X POST -H 'Content-Type: application/json' --data "@tmp/passport-nl-2014.json" https://client.balie.test.tweede.golf/scanned
