#!/bin/sh

VIDEO_ID=$1

if ! wget -O - "https://img.youtube.com/vi/${VIDEO_ID}/maxresdefault.jpg"; then
    if ! wget -O - "https://img.youtube.com/vi/${VIDEO_ID}/hqdefault.jpg"; then
        wget -O - "https://img.youtube.com/vi/${VIDEO_ID}/default.jpg"
    fi
fi
