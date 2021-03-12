#!/usr/bin/env bash

set -x

# for use with cron, eg:
# 0 3 * * * db_backup.sh /path/to/specific_db_backup.sh owncloud

if [[ -z "$1" ]]; then
    echo "Usage: $0 <db_backup_script> <db_backup_dir>"
    exit 1
fi

DATE=/opt/bin/date
GZIP=/opt/bin/gzip

DB_BACKUP_SCRIPT="$1"; shift
DB="$1"; shift
DIR="/share/mysql_backup/cumin/$DB"

KEEP_DAILY=30
KEEP_WEEKLY=5
KEEP_MONTHLY=12

function date_greater_or_equal {
  # compare seconds since epoch for the dates
  s1=$($DATE -d "$1" +%s)
  s2=$($DATE -d "$2" +%s)

  if [ $s1 -ge $s2 ]; then
    return 0
  else
    return 1
  fi
}

function rotate {
    rotation=$1
    # The rotation function shall be robust against missing backups.
    # For example, if the weekly rotation run's on Sunday, and only backups
    # until Thursday exist, then we shall rotate Thursday's (ie the most
    # recent) backup as this week's backup.
    case $rotation in
      weekly)
        # monday of current week (because rotation on Sunday)
        earliest=$($DATE -dlast-monday +%Y-%m-%d)
        most_recent_backup=$(ls -t $DIR/daily/${DB}_*.sql.gz 2>/dev/null | head -1)
        ;;
      monthly)
        # first day of previous month
        earliest=$($DATE --date="$(date +'%Y-%m-01') - 1 month" +%Y-%m-01)
        previous_month=$($DATE --date="$(date +'%Y-%m-01') - 1 month" +%m)
        most_recent_backup=$(ls -t $DIR/daily/${DB}_*-${previous_month}-*.sql.gz 2>/dev/null | head -1)
        ;;
      yearly)
        # first day of previous year
        earliest=$($DATE --date="$(date +'%Y-%m-01') - 1 year" +%Y-01-01)
        previous_year=$($DATE --date="$(date +'%Y-%m-01') - 1 year" +%Y)
        most_recent_backup=$(ls -t $DIR/daily/${DB}_${previous_year}-*.sql.gz  2>/dev/null | head -1)
        ;;
    esac

    if [ -f "$most_recent_backup" ]; then
      date_of_most_recent_backup=$(basename "$most_recent_backup" .sql.gz | sed "s/${DB}_//" -)

      if date_greater_or_equal "$date_of_most_recent_backup" "$earliest"; then
          cp -p "$most_recent_backup" "$DIR/$rotation/" || abort
      fi
    # else
    #  echo No backup found for $rotation rotation from $earliest
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

date=$($DATE +%Y-%m-%d) || abort
day=$($DATE -d "$date" +%d) || abort
weekday=$($DATE -d "$date" +%w) || abort
month=$($DATE -d "$date" +%m) || abort

# Do the daily backup
SQL_DUMP=/tmp/${DB}_$date.sql
$DB_BACKUP_SCRIPT > "$SQL_DUMP"
if [ -s "$SQL_DUMP" ]; then
  $GZIP "$SQL_DUMP" && mv $SQL_DUMP.gz "$DIR/daily/${DB}_$date.sql.gz"
fi

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
