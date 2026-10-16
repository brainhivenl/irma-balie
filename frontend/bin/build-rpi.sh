#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

sdk=${FLUTTER_SDK_PATH:-$HOME/flutter}
engine_revision=57d3bac3dd5cb5b0e464ab70e7bc8a0d8cf083ab
binaries_revision=deaf44bacae971edfa1ffe84ba39874118a622cc
snapshot_checksum=4667ad74b0b3414fe633170ef4eb91f8f3238cd8b2bbad50c32dd201d228519e
snapshot="engine-binaries/$binaries_revision/gen_snapshot_linux_x64_release"

if [[ $(uname -s) != Linux || $(uname -m) != x86_64 ]]; then
  echo 'Run this cross-build on x86_64 Linux (the output targets Raspberry Pi ARM).' >&2
  exit 1
fi

if [[ ! -f "$sdk/bin/internal/engine.version" ]] ||
   [[ $(cat "$sdk/bin/internal/engine.version") != "$engine_revision" ]]; then
  echo 'Set FLUTTER_SDK_PATH to a Flutter 2.10.4 SDK, matching the Pi engine.' >&2
  exit 1
fi

if [[ ! -f "$snapshot" ]]; then
  mkdir -p "$(dirname "$snapshot")"
  curl --fail --location --retry 2 \
    "https://raw.githubusercontent.com/ardera/flutter-engine-binaries-for-arm/$binaries_revision/arm/gen_snapshot_linux_x64_release" \
    --output "$snapshot.download"
  echo "$snapshot_checksum  $snapshot.download" | sha256sum --check
  mv "$snapshot.download" "$snapshot"
fi
echo "$snapshot_checksum  $snapshot" | sha256sum --check
chmod +x "$snapshot"

# Optional arguments (such as --offline) are passed to dependency restoration.
"$sdk/bin/flutter" pub get "$@"
"$sdk/bin/flutter" build bundle --release --no-pub
"$sdk/bin/dart" \
  "$sdk/bin/cache/dart-sdk/bin/snapshots/frontend_server.dart.snapshot" \
  --sdk-root "$sdk/bin/cache/artifacts/engine/common/flutter_patched_sdk_product/" \
  --target=flutter --aot --tfa -Ddart.vm.product=true \
  --packages .packages \
  --output-dill build/kernel_snapshot.dill \
  --depfile build/kernel_snapshot.d \
  package:irmabalie/main.dart

"$snapshot" --deterministic --snapshot_kind=app-aot-elf --strip \
  --sim-use-hardfp --elf=build/flutter_assets/app.so build/kernel_snapshot.dill

echo 'Raspberry Pi release bundle: frontend/build/flutter_assets (including app.so)'
