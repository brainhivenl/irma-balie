# irmabalie Frontend

## Languages

The welcome screen offers Nederlands and English. Dutch is the default; the
selected language stays active while navigating the kiosk and returning to the
welcome screen. Restarting the app restores Dutch. Credential labels and dates
follow the selected language, with Dutch fallback for untranslated values.

Kiosk translations live under `kiosk` in `assets/locales/nl.json` and `en.json`.
Keep placeholders such as `{id}` and document asset paths aligned between them.

Use Flutter **2.10.4** (Dart 2.16.2), matching the Raspberry Pi engine, for this
legacy project. From `frontend`, verify changes with:

```bash
flutter pub get
flutter test
flutter build bundle --release
```

The bundle build does not generate the Raspberry Pi AOT binary. That still
requires the matching ARM engine's `gen_snapshot` step below.

For debugging on your development machine fetch Hover and run

```bash
hover run
```

In order to build a package that can run directly on the Raspberry Pi package with flutter:

```bash
flutter build bundle
```

## Build and deploy on Raspberry Pi

On x86_64 Linux, use the pinned cross-build script:

```bash
FLUTTER_SDK_PATH=~/fvm/versions/2.10.4 bash bin/build-rpi.sh
```

Append `--offline` when all locked dependencies are already cached.

It checks the SDK engine revision and downloads the matching ARM snapshot
compiler from archived engine-binaries commit
`deaf44bacae971edfa1ffe84ba39874118a622cc`, verified with SHA-256. It produces
`build/flutter_assets/`, including the ARM `app.so`. The Pi's installed Flutter
engine must match Flutter 2.10.4 (engine `57d3bac3dd`).

Copy the resulting bundle to the Pi using your normal deployment procedure:

```bash
scp -r ./build/flutter_assets/ pi@irma-balie-02:/home/pi/irma-balie/frontend
```
