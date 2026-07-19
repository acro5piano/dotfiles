#!/bin/bash

# Usage:
#   video-cutter.sh /mnt/DCIM/100GOPRO/GX010499.MP4 8:53 9:03

set -euo pipefail

file=$1
start=$2
end=$3

output="${file%.*}-sliced.mp4"

ffmpeg \
  -ss "$start" \
  -to "$end" \
  -i "$file" \
  -y \
  -vf "scale=1280:720:force_original_aspect_ratio=decrease:force_divisible_by=2" \
  -c:v libx264 \
  -preset veryfast \
  -crf 27 \
  -c:a aac \
  -b:a 96k \
  -movflags +faststart \
  "$output"
