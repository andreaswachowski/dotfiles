#!/bin/sh
# https://brandur.org/fragments/ffmpeg-h265

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) <input.mov>"
    exit 1
fi

INPUT=$1

if [ ! -f "$INPUT" ]; then
    echo "File $INPUT not found"
    exit 1
fi

INPUT_WITHOUT_EXTENSION="$(basename "$INPUT" | sed 's/\(.*\)\..*/\1/')"
OUTPUT=$INPUT_WITHOUT_EXTENSION.mkv

ffmpeg -i $INPUT -c:v libx265 -preset fast -crf 28 -tag:v hvc1 -c:a eac3 -b:v 224k $OUTPUT
