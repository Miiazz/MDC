#!/bin/bash

LOCK_FILE="/home/mdcontroller/scripts/updating.lock"
VIDEO_DIR="/home/mdcontroller/videos"
URL_FILE="/home/mdcontroller/scripts/yt_urls.txt"

# Logging (optional but recommended)
LOGFILE="/home/mdcontroller/scripts/update.log"
exec > >(tee -a "$LOGFILE") 2>&1

# Prevent overlapping updates
if [ -f "$LOCK_FILE" ]; then
  echo "Update already in progress. Skipping."
  exit 1
fi

# Only continue if URL file exists
if [ ! -f "$URL_FILE" ]; then
  echo "No yt_urls.txt file found!"
  exit 1
fi

touch "$LOCK_FILE"
cd "$VIDEO_DIR"
echo "Clearing old videos..."
rm -f *.mp4

echo "Starting video downloads..."
yt-dlp \
  --write-auto-subs \
  --sub-lang en \
  --embed-subs \
  --merge-output-format mp4 \
  -f "bv*[height<=720]+ba" \
  -a "$URL_FILE"

chmod 644 "$VIDEO_DIR"/*.mp4
pkill mpv

echo "Done!"
rm -f "$LOCK_FILE"

