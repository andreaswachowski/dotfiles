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

FILES=$(mdfind -onlyin "$DIRECTORY" "kMDItemFSName==*.mp3&&kMDItemAudioBitRate<${MAX_BITRATE}000")

IFS=$'\n' read -r -d '' -a FILE_ARRAY <<<"$FILES"

echo "Filename;Bitrate (kbps);Sample Rate (Hz)"

get_bitrate_and_samplerate_with_mdls() {
  FILE="$1"
  mdls -name kMDItemAudioBitRate -name kMDItemAudioSampleRate -raw "$FILE" | xargs -0
}

get_bitrate_and_samplerate_with_ffprobe() {
  FILE=$1
  ffprobe -v error -select_streams a:0 -show_entries stream=bit_rate,sample_rate -of default=noprint_wrappers=1:nokey=1 "$FILE" | tr '\n' ' '
}

for FILE in "${FILE_ARRAY[@]}"; do
  if [ -f "$FILE" ]; then
    BITRATE_SAMPLERATE=$(get_bitrate_and_samplerate_with_$ANALYZE_CMD "$FILE")
    IFS=' ' read -r BITRATE SAMPLE_RATE <<<"$BITRATE_SAMPLERATE"

    # Convert bitrate to kbps
    BITRATE_KBPS=$((BITRATE / 1000))

    # Display the filename and quality information
    echo "$FILE;${BITRATE_KBPS};${SAMPLE_RATE}"
  fi
done
