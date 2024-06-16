#!/usr/bin/env bash
# Also see https://superuser.com/questions/439771/command-line-tool-to-identify-audio-file-specs
#
# mdls -name kMDItemFSName -name kMDItemAudioBitRate
# mdfind -onlyin ~/audio/ 'kMDItemFSName==*.mp3&&kMDItemAudioBitRate<=192000'

DIRECTORY=.

MAX_BITRATE=192

displayUsageScreen() {
  cat <<-HERE
	Usage: $ScriptName [-b <acceptable_bit_rate>] <directory>

	Finds MP3 files of less than max_bit_rate.

	If no directory is given, searches in the current directory.

	Options:
	  -h          : Displays this screen
	  -b <bitrate>: The acceptable bit rate. Files with a lower bit rate are found.
HERE
}

ScriptName=$(basename "$0")

if ! command -v mdls &>/dev/null; then
  if ! command -v ffprobe &>/dev/null; then
    echo "Neither mdls (only MacOS) nor ffprobe found, please install ffmpeg."
    exit 1
  else
    ANALYZE_CMD=ffprobe
  fi
else
  ANALYZE_CMD=mdls
fi

while getopts "hb:" OPT; do
  case "$OPT" in
  b)
    MAX_BITRATE=$OPTARG
    ;;

  h)
    displayUsageScreen
    exit 1
    ;;

  :)
    print -u2 "Incorrect Syntax: -${OPTARG} needs argument."
    displayUsageScreen
    exit 1
    ;;

  \?)
    print -u2 "Incorrect Syntax: -${OPTARG} bad option."
    displayUsageScreen
    exit 1
    ;;
  esac
done

shift $(("$OPTIND" - 1))

if [ -n "$1" ]; then
  DIRECTORY=$1
else
  DIRECTORY=.
fi

echo "Filename;Bitrate (kbps);Sample Rate (Hz)"

get_bitrate_and_samplerate_with_mdls() {
  mdls -name kMDItemAudioBitRate -name kMDItemAudioSampleRate -name kMDItemFSName -raw "$@" | tr '\0' ';'
}

get_bitrate_and_samplerate_with_ffprobe() {
  FILE=$1
  ffprobe -v error -select_streams a:0 -show_entries stream=bit_rate,sample_rate -of default=noprint_wrappers=1:nokey=1 "$FILE" | tr '\n' ' '
}

# https://www.shellcheck.net/wiki/SC2044
while IFS= read -r -d '' DIRECTORY; do
  FILES=$(mdfind -onlyin "$DIRECTORY" "kMDItemFSName==*.mp3&&kMDItemAudioBitRate<${MAX_BITRATE}000")
  IFS=$'\n' read -r -d '' -a DIR_FILES <<<"$FILES"

  if [ ${#DIR_FILES[@]} -gt 0 ]; then
    BITRATE_SAMPLERATE_FILENAME=$(get_bitrate_and_samplerate_with_$ANALYZE_CMD "${DIR_FILES[@]}")
    echo "$BITRATE_SAMPLERATE_FILENAME" | awk -v dir="$DIRECTORY" -F';' '{
        for (i = 1; i <= NF; i += 3) {
          print dir "/" $(i+2) ";" $i/1000 ";" $(i+1)
        }
    }'
  fi
done < <(find "$DIRECTORY" -type f -name '*.mp3' -print0 | xargs -0 -n1 dirname | sort -u | tr '\n' '\0')
