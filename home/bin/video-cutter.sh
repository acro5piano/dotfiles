#!/bin/bash

# Usage:
#   video-cutter.sh /mnt/DCIM/100GOPRO/GX010499.MP4 8:53 9:03

set -euo pipefail

file=$1
start=$2
end=$3

output="${file%.*}-slice-${start//:}-${end//:}.mp4"

ffmpeg \
  -ss "$start" \
  -to "$end" \
  -i "$file" \
  -y \
  -c copy \
  -movflags +faststart \
  "$output"
