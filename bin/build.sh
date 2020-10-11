#!/usr/bin/env bash

set -euo pipefail

# TODO docker & jenkins

echo -n "Building irma-balie "

if [[ $(git diff --stat) != "" ]]; then
  echo -n "(dirty!)"
else
  echo -n "(clean)"
fi

echo -n " @ "

git rev-parse --short HEAD

echo "-- Removing any pre-existing distributions"
mkdir -p ./dist
rm -rf ./dist/*

echo "-- Building client"
pushd client > /dev/null
env GOARCH=arm go build -o ../dist/client_arm
env GOARCH=amd64 go build -o ../dist/client_amd64
popd > /dev/null

echo "-- Building server"
pushd server > /dev/null
env GOARCH=arm go build -o ../dist/server_arm
env GOARCH=amd64 go build -o ../dist/server_amd64
popd > /dev/null

echo "-- Building mrtd-scanner"
pushd mrtd-scanner > /dev/null
./gradlew build
cp build/distributions/mrtdscanner.tar ../dist/mrtdscanner.tar
popd > /dev/null

echo "-- Building mrtd-unpack"
pushd mrtd-unpack > /dev/null
./gradlew build
cp build/distributions/mrtdunpack.tar ../dist/mrtdunpack.tar
popd > /dev/null

echo "-- Building frontend"
pushd frontend > /dev/null
rm -rf build
flutter build bundle
pushd build/flutter_assets/ > /dev/null
tar -cf ../../../dist/frontend.tar *
popd > /dev/null
tar -rf ../dist/frontend.tar app.so
popd > /dev/null

echo "-- Compressing artifacts"
bzip2 -z ./dist/*

sha256sum dist/*

echo "-- Build complete, see /dist"
