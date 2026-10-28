#!/bin/sh

CYANRIP=/usr/bin/cyanrip
LIBRARY=/audio/audiolibrary

# Per type: target directory below $LIBRARY, and whether to sort into a
# per-artist subdirectory. Various-artists releases (compilations, soundtracks)
# put the artist into the track file name instead. Kept as a string so that
# shfmt leaves the column alignment alone.
TYPES='
album       Alben/flac        yes
comedy      Comedy            yes
compilation Compilations/flac no
single      Single-CDs/flac   yes
soundtrack  Soundtracks/flac  no
'

usage() {
  names=$(printf '%s\n' "$TYPES" | awk 'NF { printf "%s%s", sep, $1; sep = "|" }')
  echo "Usage: $(basename "$0") <$names> <decade> [<release-id>]"
  exit 1
}

[ -n "$2" ] || usage

TYPE=$1
DECADE=$2
RELEASE=$3

read -r DIR BY_ARTIST <<EOF
$(printf '%s\n' "$TYPES" | awk -v t="$TYPE" '$1 == t { print $2, $3 }')
EOF
[ -n "$DIR" ] || usage

if [ "$BY_ARTIST" = yes ]; then
  ARTIST_DIR="{album_artist}/"
  TRACK_NAME="{track} - {title}"
else
  ARTIST_DIR=""
  TRACK_NAME="{track} - {artist} - {title}"
fi

if [ -n "$RELEASE" ]; then
  set -- -R "$RELEASE"
else
  set --
fi

# Note (from https://github.com/cyanreg/cyanrip#replaygain): cyanrip will
# automatically compute ReplayGain tags and add them to all files while ripping.
# Note, that this requires to hold all compressed audio data for the entire CD
# in RAM while ripping, which may be from 300 to 600 megabytes, depending on the
# output used. Low-power and low-RAM devices can turn this off via the -K
# switch.
$CYANRIP -d /dev/sr0 -s 6 \
  -D "$LIBRARY/$DIR/$DECADE/{year}/$ARTIST_DIR{album}{if #releasecomment# > #0# (|releasecomment|)}{if #totaldiscs# > #1#/CD |disc|}" \
  "$@" \
  -T simple \
  -F "$TRACK_NAME" \
  -L "{album}{if #totaldiscs# > #1# CD |disc|}" \
  -M "{album}{if #totaldiscs# > #1# CD |disc|}"
