#!/usr/bin/env bash

# Sync from salt to cumin
# vi: tw=0 ts=2 sw=2 expandtab
# TODO:
# Option -n passed on commandline of this script
# Option -d [cumin/imac] passed on commandline of this script
#
# Whenever I move a directory, the original directory is left
# dangling after the rsync on cumin, because, on nutmeg, it includes also
# the '*__thumb*' files not available on salt.
# Using delete-excluded will delete *all* the __thumb-files, whether or not
# they are in a moved directory.
#
# As usual, others are having exactly the same problem:
# (google for "rsyn cannot delete non-empty directory")
#
# http://www.linuxquestions.org/questions/slackware-14/cant-remove-non-empty-directory-with-rsync-694546/
#
# The only solution I currently have is to manually delete those files
# I could extend this script to analyze the error messages and then do it
# automatically

displayUsageScreen() {
	# <<- as opposed to << strips the leading tabs from the output
	cat <<- HERE
	Usage: $ScriptName [-hmn] [-d host] [Subdirectory]

  Synchronizes audio files between hosts.
  Unless a subdirectory is given the whole /audio directory is used.

	Options:
	           -h : Displays this screen
	           -m : Performs a backup of the Amarok mysql database first
	           -n : Appends "n" to rsync to perform a dry run
	     -d host: Specifies the destination host. Default is pve
	HERE
}

ScriptName=$(basename "$0")

# -------------------------------------------------------------------------
while getopts "hmnd:" OPT
do
    case "$OPT" in
    d) DEST=$OPTARG
       ;;

    m) mysqldump -u amarokuser -pbla32mar0K amarokdb | gzip > /audio/amarok.sql.gz
       ;;

    n) RSYNCOPTS=n
       ;;

    h) displayUsageScreen
       exit 1
       ;;

    :) print -u2 "Incorrect Syntax: -${OPTARG} needs argument."
       displayUsageScreen
       exit 1
       ;;

    \?) print -u2 "Incorrect Syntax: -${OPTARG} bad option."
        displayUsageScreen
        exit 1
        ;;
    esac
done

shift $(("$OPTIND" - 1))


case "$(hostname -s)" in
  salt) SRC=/audio/audiolibrary
    ICONV_SRC=UTF8
    ;;
  macbook2021) SRC=/Users/andreas/audio
    ICONV_SRC=UTF8-MAC
    ;;
  *) echo "Unknown source. Aborting"
    exit 1
    ;;
esac

if [ -z "$DEST" ]; then
  DEST=pve
fi

if [ -n "$1" ]; then
  DIR=$1
fi

case "$DEST" in
  salt) ROOT=/audio/audiolibrary
    ICONV_DEST=UTF8
    ;;
  pve) ROOT=/audio/audiolibrary
    ICONV_DEST=UTF8
    ;;
  imac) ROOT=/Volumes/HDD2/audio/audiolibrary
    ICONV_DEST=UTF8-MAC
    RSYNC_PATH="--rsync-path=/usr/local/bin/rsync"
    ;;
  macbook2021) ROOT=/Users/andreas/audio
    ICONV_DEST=UTF8-MAC
    RSYNC_PATH="--rsync-path=/usr/local/bin/rsync"
    ;;
  *) echo "Unknown destination $DEST, aborting."
    exit 1
    ;;
esac

ICONV="--iconv=$ICONV_SRC,$ICONV_DEST"
#rsync -av --exclude '*__thumb*' --delete-after /audio/ cumin:/share/audio
#rsync -av --iconv=UTF8,UTF8-MAC --exclude '*__thumb*' --delete-after /audio/ imac:/Volumes/HDD2/audio

echo rsync -av${RSYNCOPTS} ${ICONV} ${RSYNC_PATH} --exclude '*__thumb*' --exclude 'lost+found' --delete-after $SRC${DIR:+/$DIR}/ ${DEST}:${ROOT}${DIR:+/$DIR}
rsync -av${RSYNCOPTS} ${ICONV} ${RSYNC_PATH} --exclude '.DS_Store' --exclude '*__thumb*' --exclude 'lost+found' --delete-after $SRC${DIR:+/$DIR}/ ${DEST}:${ROOT}${DIR:+/$DIR}
