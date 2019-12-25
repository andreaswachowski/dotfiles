#!/bin/bash

if [ $# -lt 1 ]; then
  cat <<EOF
Usage: §$(basename "$0") <playlist-file>

The playlist file must have UNIX line endings and be encoded in UTF8 *without* BOM.
EOF
  exit 1
fi

FILELIST=$1
PLAYLIST_DIR=$(basename "$(basename "$FILELIST" .m3u8)" .m3u)

if [ ! -d "$PLAYLIST_DIR" ]; then
  mkdir "$PLAYLIST_DIR"
fi

i=0
while IFS= read -r file
do
  i=$((i + 1))
  newfile=$PLAYLIST_DIR/$(printf "%02d - " $i)$(basename "$file")
  cp -- "$file" "$newfile"
done < "$FILELIST"
