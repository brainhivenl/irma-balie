#!/usr/bin/env bash
cd `dirname "${BASH_SOURCE[0]}"`
if [ -z "$1" ]
then
    gradle -q run
else
    gradle -q run --args="$1"
fi
