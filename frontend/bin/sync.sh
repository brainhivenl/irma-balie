#!/usr/bin/env bash

RPI_HOST=${RPI_HOST:-192.168.30.230}
RPI_USER=${RPI_USER:-pi}
RPI_TARGET=${RPI_HOME:-/home/pi/irma-balie-frontend}

echo "--- Copying asset bundle"
rsync -ah --delete --info=progress2 ./build/flutter_assets/ "${RPI_USER}@${RPI_HOST}:${RPI_TARGET}"
if [ -f ./build/app.so ]; then
  echo "--- Copying release binary"
  scp ./build/app.so "${RPI_USER}@${RPI_HOST}:${RPI_TARGET}/app.so"
else
  echo "--- Warning: No release binary found, skipping"
fi
