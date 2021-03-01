#!/usr/bin/env bash

set -x

# for use with cron, eg:
# 0 3 * * * db_backup.sh /path/to/specific_db_backup.sh owncloud

if [[ -z "$1" ]]; then
    echo "Usage: $0 <db_backup_script> <db_backup_dir>"
    exit 1
fi

DB_BACKUP_SCRIPT="$1"; shift
DB="$1"; shift
DIR="/share/mysql_backup/cumin/$DB"

GZIP=/opt/bin/gzip

KEEP_DAILY=30
KEEP_WEEKLY=5
KEEP_MONTHLY=12

function rotate {
    rotation=$1
    fdate=$(date +%Y-%m-%d -d "$date")
    file=$DIR/daily/*$fdate*.gz # In Assignment, globs are *not* expanded
    # In the if-statement, $file must be unquoted to be expanded
    if [ -f $file ]; then
        cp -p $file "$DIR/$rotation/" || abort
    else
        echo
    fi
}

function prune {
    dir=$DIR/$1
    keep=$2
    ls "$dir" | sort -rn | awk " NR > $keep" | while read f; do rm "$dir/$f"; done
}

function abort {
    echo "aborting..."
    exit 1
}

mkdir -p "$DIR/daily" || abort
mkdir -p "$DIR/weekly" || abort
mkdir -p "$DIR/monthly" || abort
mkdir -p "$DIR/yearly" || abort

date=$(date +%Y-%m-%d) || abort
day=$(date -d "$date" +%d) || abort
weekday=$(date -d "$date" +%w) || abort
month=$(date -d "$date" +%m) || abort

# Do the daily backup
$DB_BACKUP_SCRIPT | $GZIP > "$DIR/daily/${DB}_$date.sql.gz"
test ${PIPESTATUS[0]} -eq 0 || abort

# Perform rotations
if [[ "$weekday" == "0" ]]; then
    rotate weekly
fi
if [[ "$day" == "01" ]]; then
    rotate monthly
fi
if [[ "$month/$day" == "01/01" ]]; then
    rotate yearly
fi

prune daily $KEEP_DAILY
prune weekly $KEEP_WEEKLY
prune monthly $KEEP_MONTHLY
