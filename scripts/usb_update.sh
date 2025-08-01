#!/bin/bash

MOUNTDIR="/media/mdcontroller"
VIDDIR="/home/mdcontroller/videos"
LOGFILE="/home/mdcontroller/scripts/update.log"

# Logging
exec > >(tee -a "$LOGFILE") 2>&1

# Look for USB drives with yt_urls.txt
for usb in "$MOUNTDIR"/*; do
    if [ -f "$usb/yt_urls.txt" ]; then
        echo "$(date): Found yt_urls.txt on $usb. Updating videos..."

        echo "$(date): Clearing old videos..."
        rm -f "$VIDDIR"/*.mp4

        yt-dlp \
            --merge-output-format mp4 \
	    --format "bv*[vcodec^=avc1][height<=720]+ba[acodec^=mp4a]" \
            --download-archive /home/mdcontroller/scripts/downloaded.txt \
            -o "%(title)s.%(ext)s" \
            -a "$usb/yt_urls.txt" \
            -P "$VIDDIR"

        echo "$(date): Setting permissions..."
        chmod 644 "$VIDDIR"/*.mp4

        echo "$(date): Restarting mpv-loop.service..."
        systemctl --user restart mpv-loop.service

        echo "$(date): USB update complete."
        exit 0
    fi
done

echo "$(date): No yt_urls.txt found on any USB drives."
exit 1

