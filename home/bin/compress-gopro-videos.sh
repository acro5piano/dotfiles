#!/bin/bash
set -euo pipefail
shopt -s nullglob nocaseglob

SRC="/mnt/DCIM/100GOPRO"
DST="$HOME/gopro"
BITRATE="3M"

if mountpoint -q /mnt; then
    echo "Already mounted: /mnt"
elif [ -e /dev/mmcblk0p1 ]; then
    sudo mount -o uid=1000,gid=1000 /dev/mmcblk0p1 /mnt
elif [ -e /dev/sda1 ]; then
    sudo mount -o uid=1000,gid=1000 /dev/sda1 /mnt
fi

if [ ! -e "$SRC" ]; then
    echo "Not mounted: $SRC is missing"
    exit 1
fi

for f in "$SRC"/*.MP4; do
  month=$(date -r "$f" +%Y%m)
  timestamp=$(date -r "$f" +%Y%m%d-%H%M%S)
  out="$DST/$month/${timestamp}.mp4"
  mkdir -p "$DST/$month"

  if [ -f "$out" ]; then
    echo "SKIP (exists): $out"
    continue
  fi

  tmp="${out}.tmp.mp4"
  echo "ENCODE: $f -> $out"
  ffmpeg -nostdin -i "$f" \
    -c:v libx265 -b:v "$BITRATE" -preset medium \
    -c:a aac -b:a 128k \
    -movflags +faststart \
    -n "$tmp"
  mv "$tmp" "$out"
  touch -r "$f" "$out"
done
