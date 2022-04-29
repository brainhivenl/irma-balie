# irmabalie Frontend

For debugging on your development machine fetch Hover and run

```bash
hover run
```

In order to build a package that can run directly on the Raspberry Pi package with flutter:

```bash
flutter build bundle
```

## deploy frontend on rpi (version flutter v2.10.4 for latest https://github.com/ardera/flutter-engine-binaries-for-arm)
```bash
/src/irma-balie/frontend$ fvm flutter clean

/src/irma-balie/frontend$ fvm flutter pub get

/src/irma-balie/frontend$ flutter build bundle

/src/irma-balie/frontend$ ~/fvm/versions/2.10.4/bin/dart ~/fvm/versions/2.10.4/bin/cache/dart-sdk/bin/snapshots/frontend_server.dart.snapshot --sdk-root ~/fvm/versions/2.10.4/bin/cache/artifacts/engine/common/flutter_patched_sdk_product/ --target=flutter --aot --tfa -Ddar.vm.product=true --packages .packages --output-dill build/kernel_snapshot.dill --depfile build/kernel_snapshot.d package:irmabalie/main.dart

/src/irma-balie/frontend$ ~/src/engine-binaries/arm/gen_snapshot_linux_x64_release --deterministic --snapshot_kind=app-aot-elf --strip --sim-use-hardfp --elf=build/flutter_assets/app.so build/kernel_snapshot.dill

scp -r ./build/flutter_assets/ pi@irma-balie-02:/home/pi/irma-balie/frontend
```