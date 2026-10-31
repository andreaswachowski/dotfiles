#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $(basename "$0") <file> "
  exit 1
fi

OUTFILE=$HOME/printer_inbox/$1

# Pixma requires pixma commented in in
# /etc/sane.d/dll/conf
# and also the line "mfnp://10.91.40.4 in /etc/sane.d/pixma.conf
# Then check with "scanimage -L" whether the printer is shown.
scanimage -d 'pixma:MF645C_10.91.40.4' \
  --source Flatbed \
  --mode Color \
  --resolution 600 \
  --format=png \
  -o "$OUTFILE"
