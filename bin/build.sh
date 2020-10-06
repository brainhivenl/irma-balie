#!/usr/bin/env bash

# TODO docker & jenkins

rm -rf ./dist
mkdir ./dist

pushd client
env GOARCH=arm64 go build -o ../dist/client_arm64
env GOARCH=amd64 go build -o ../dist/client_amd64
popd

pushd server
env GOARCH=arm64 go build -o ../dist/server_arm64
env GOARCH=amd64 go build -o ../dist/server_amd64
popd

pushd mrtd-scanner
./gradlew build
cp build/distributions/mrtdscanner.tar ../dist/mrtdscanner.tar
popd

pushd mrtd-unpack
./gradlew build
cp build/distributions/mrtdunpack.tar ../dist/mrtdunpack.tar
popd
