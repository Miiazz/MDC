#!/bin/bash

LOCK_FILE="/home/mdcontroller/scripts/updating.lock"
VIDEO_DIR="/home/mdcontroller/videos"
URL_FILE="/home/mdcontroller/scripts/yt_urls.txt"
LOGFILE="/home/mdcontroller/scripts/update.log"

# Logging
exec > >(tee -a "$LOGFILE") 2>&1

# Prevent overlapping updates
if [ -f "$LOCK_FILE" ]; then
  echo "$(date): Update already in progress. Skipping."
  exit 1
fi

# Exit early if URL list doesn't exist
if [ ! -f "$URL_FILE" ]; then
  echo "$(date): No yt_urls.txt file found!"
  exit 1
fi

touch "$LOCK_FILE"
cd "$VIDEO_DIR" || exit 1

echo "$(date): Clearing old videos..."
rm -f *.mp4

echo "$(date): Starting video downloads..."
yt-dlp \
  --merge-output-format mp4 \
  --format "bv*[vcodec^=avc1][height<=720]+ba[acodec^=mp4a]" \
  --download-archive /home/mdcontroller/scripts/downloaded.txt \
  -o "%(title)s [%(id)s].%(ext)s" \
  -a "$URL_FILE"

echo "$(date): Setting file permissions..."
chmod 644 "$VIDEO_DIR"/*.mp4

# Restart the systemd user service (safer than pkill)
echo "$(date): Restarting video loop..."
systemctl --user restart mpv-loop.service

echo "$(date): Update complete."
rm -f "$LOCK_FILE"

