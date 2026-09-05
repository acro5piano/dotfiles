#!/usr/bin/env bash

set -e

DIR="${1:-.}"
OUTPUT="${2:-merged.mp4}"
LIST_FILE="$(mktemp)"

cleanup() {
  rm -f "$LIST_FILE"
}
trap cleanup EXIT

DIR="$(realpath "$DIR")"
OUTPUT_PATH="$DIR/$OUTPUT"

if [[ ! -d "$DIR" ]]; then
  echo "Directory does not exist: $DIR"
  exit 1
fi

find "$DIR" -maxdepth 1 -type f -name '*.mp4' \
  ! -path "$OUTPUT_PATH" \
  | sort \
  | while IFS= read -r file; do
      printf "file '%s'\n" "$file"
    done > "$LIST_FILE"

if [[ ! -s "$LIST_FILE" ]]; then
  echo "No MP4 files found in: $DIR"
  exit 1
fi

echo "Merging the following files:"
cat "$LIST_FILE"
echo

ffmpeg \
  -f concat \
  -safe 0 \
  -i "$LIST_FILE" \
  -c copy \
  "$OUTPUT_PATH"

echo
echo "Done: $OUTPUT_PATH"
