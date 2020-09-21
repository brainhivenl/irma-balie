#!/usr/bin/env bash

set -eo pipefail

function stop_ffmpeg() {
  if [ ! -z "$ffmpeg_pid" ]; then
    kill "$ffmpeg_pid"
  fi
}

trap stop_ffmpeg EXIT

WITH_SCREENGRAB=${WITH_SCREENGRAB:-1}

if [ "$WITH_SCREENGRAB" -eq 1 ]; then
  V4L2LOOPBACK_DEVICE=${V4L2LOOPBACK_DEVICE:-/dev/video0}
  ffmpeg -f x11grab \
    -r 15 \
    -s 1080x1497 \
    -i :0.0+0,0 \
    -vf 'transpose=3,hflip,scale=1280:720' \
    -vcodec rawvideo \
    -pix_fmt yuv420p \
    -threads 0 \
    -f v4l2 \
    "${V4L2LOOPBACK_DEVICE}" &
  sleep 2
  ffmpeg_pid=$!
  echo "--- Started ffmpeg screen capture to ${V4L2LOOPBACK_DEVICE}"
fi

if [ ! -z "$V4L2LOOPBACK_DEVICE" ] && [ -z "$EMULATOR_VIDEO_DEVICE" ]; then
  echo "--- Attempting to discover android emulator webcam device to use for v4l2loopback device"
  EMULATOR_VIDEO_DEVICE=$("$ANDROID_SDK_ROOT/emulator/emulator" -webcam-list | grep "$V4L2LOOPBACK_DEVICE" | cut -d' ' -f3 | cut -d"'" -f2)
fi

EMULATOR_VIDEO_DEVICE=${EMULATOR_VIDEO_DEVICE:-virtualscene}
echo "--- Using video device: ${EMULATOR_VIDEO_DEVICE}"

"$ANDROID_SDK_ROOT/emulator/emulator" @irma -camera-back "$EMULATOR_VIDEO_DEVICE" -no-snapshot &
emulator_pid=$!
while [ "`adb shell getprop sys.boot_completed | tr -d '\r' `" != "1" ] ; do sleep 1; done

# boot completed gets triggered a little soon, so we will wait a few more seconds
echo "--- Boot completed, waiting a little while for emulator to settle"
sleep 3

echo "--- Installing IRMA app"
"$ANDROID_SDK_ROOT/platform-tools/adb" install tmp/app.apk

echo "--- Starting IRMA app"
"$ANDROID_SDK_ROOT/platform-tools/adb" shell am start -n foundation.privacybydesign.irmamobile.alpha/foundation.privacybydesign.irmamobile.MainActivity

echo "--- Waiting for the emulator"
wait $emulator_pid
