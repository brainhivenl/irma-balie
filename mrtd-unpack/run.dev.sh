#!/usr/bin/env bash
cd `dirname "${BASH_SOURCE[0]}"`
./gradlew -q run --args=stdin
