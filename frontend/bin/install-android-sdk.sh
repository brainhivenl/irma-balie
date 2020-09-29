#!/usr/bin/env bash


"$ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager" 'cmdline-tools;latest' \
  'ndk-bundle' \
  'platforms;android-28' \
  'build-tools;28.0.3' \
  'system-images;android-28;google_apis_playstore;x86_64' \
  'system-images;android-28;google_apis_playstore;x86'
"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/avdmanager" create avd -n irma -d "pixel_3a" -k 'system-images;android-28;google_apis_playstore;x86'
