#!/bin/bash

# Only autoplay on physical terminal (TTY1), not SSH
if [[ -z "$SSH_CONNECTION" && "$(tty)" == "/dev/tty1" ]]; then
    sleep 2  # optional: allow system to finish loading
    exec mpv --fs --loop-playlist=inf ~/videos/*.mp4
fi
