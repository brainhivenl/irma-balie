#!/usr/bin/env bash

set -euo pipefail

rm -rf frontend mrtdunpack mrtdscanner

echo "-- Decompressing"
bzip2 -d ./*.bz2

echo "-- Unpackking"
mkdir frontend
pushd frontend > /dev/null
tar -xf ../frontend.tar
popd > /dev/null

tar -xf ./mrtdunpack.tar
tar -xf ./mrtdscanner.tar

echo "-- Getting certificates"
mkdir -p roots
pushd roots > /dev/null

rm -f nl-csca-certificates.zip
wget https://www.npkd.nl/files/nl-csca-certificates.zip

if [[ $(sha256sum nl-csca-certificates.zip) != "4b5a088fce7f57cf43742ecb854ff7b2b55d91d5b17f41e35ed09f5ec2bbd4ff  nl-csca-certificates.zip" ]]; then
  echo "-- ERROR Certificates check failed."
  exit 1
else
  echo "-- Certificates check OK."
fi

unzip nl-csca-certificates.zip
rm nl-csca-certificates.zip
popd > /dev/null

echo "-- Unpack complete!"
