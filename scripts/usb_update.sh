#!/bin/bash

MOUNTDIR="/media/mdcontroller"
VIDDIR="/home/mdcontroller/videos"

# Logging (optional)
LOGFILE="/home/mdcontroller/scripts/update.log"
exec > >(tee -a "$LOGFILE") 2>&1

# Look for USB mount with yt_urls.txt
for usb in "$MOUNTDIR"/*; do
    if [ -f "$usb/yt_urls.txt" ]; then
        echo "Found yt_urls.txt on $usb. Updating videos..."
        yt-dlp -f "bv*[height<=720]+ba" --embed-subs -a "$usb/yt_urls.txt" -P "$VIDDIR"

        chmod 644 "$VIDDIR"/*.mp4
        pkill mpv

        echo "Update complete."
        exit 0
    fi
done

echo "No yt_urls.txt found on any USB drives."
exit 1

