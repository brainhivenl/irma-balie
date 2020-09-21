#!/usr/bin/env bash

set -eo pipefail

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
  "${V4L2LOOPBACK_DEVICE}"
