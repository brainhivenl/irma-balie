#!/usr/bin/env bash

set -eo pipefail

build_release=false
update=false
clean=false
snapshot=true

while [[ $# -gt 0 ]]
do
key="$1"
shift
case $key in
    --clean)
    clean=true
    ;;
    --update)
    update=true
    ;;
    --release)
    build_release=true
    ;;
    --no-snapshot)
    snapshot=false
    ;;
    *)
    echo "--- Unknown option: $key" 1>&2
    ;;
esac
done

if [ "$clean" = true ]; then
  echo "--- Clearing build directory"
  rm -rf "./build"
fi

if [ "$snapshot" = true ]; then
  echo "--- Build the resource bundle"
  flutter build bundle --release

  echo "--- Building kernel snapshot"
  FLUTTER_SDK_PATH=${FLUTTER_SDK_PATH:-$HOME/flutter}
  "${FLUTTER_SDK_PATH}/bin/dart" \
    "${FLUTTER_SDK_PATH}/bin/cache/dart-sdk/bin/snapshots/frontend_server.dart.snapshot" \
    --sdk-root "${FLUTTER_SDK_PATH}/bin/cache/artifacts/engine/common/flutter_patched_sdk_product" \
    --target flutter \
    --aot \
    --tfa \
    -Ddart.vm.product=true \
    --packages .packages \
    --output-dill build/kernel_snapshot.dill \
    --verbose \
    --depfile build/kernel_snapshot.d \
    package:irmabalie/main.dart
fi

if [ "$build_release" = true ]; then
  if [ -d ./engine-binaries ]; then
    if [ "$update" = true ]; then
      echo "--- Updating flutter engine binaries"
      (cd ./engine-binaries && git reset --hard origin/engine-binaries && git pull)
      chmod +x ./engine-binaries/gen_snapshot_linux_x64
    fi
  else
    echo "--- Cloning flutter engine binaries"
    git clone --branch engine-binaries https://github.com/ardera/flutter-pi ./engine-binaries
    chmod +x ./engine-binaries/gen_snapshot_linux_x64
  fi

  echo "--- Building release binary"
  ./engine-binaries/gen_snapshot_linux_x64 \
    --causal_async_stacks \
    --deterministic \
    --snapshot_kind=app-aot-elf \
    --elf=build/app.so \
    --strip \
    --sim_use_hardfp \
    --no-use-integer-division \
    build/kernel_snapshot.dill
fi
echo "--- Build completed"
