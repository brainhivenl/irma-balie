#!/usr/bin/env bash

set -eo pipefail

curl -k https://client.balie.test.tweede.golf/submit | qrencode -t ANSI -o -
