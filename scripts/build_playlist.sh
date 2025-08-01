#!/bin/bash
find /home/mdcontroller/videos -maxdepth 1 -type f -iname "*.mp4" | sort > /home/mdcontroller/videos/playlist.m3u
