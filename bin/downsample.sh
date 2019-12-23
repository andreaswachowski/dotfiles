#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Usage: $(basename $0) <directory>"
  exit 1
fi

DIR=$1

find "$DIR" -name '*.mp3' | while read -d $'\n' file
do
  filedir=128k/$(dirname "$file")
  if [ ! -d "$filedir" ]; then
    mkdir -p "$filedir"
  fi
  newfile=128k/$file
  if [ ! -f "$newfile" ]; then
    lame --mp3input -b 128 "$file" "$newfile"
  else
    echo "$newfile exists already, skipping..."
  fi
done
