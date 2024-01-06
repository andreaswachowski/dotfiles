#!/bin/sh

MAILDIR_ROOT=${HOME}/Mail
MIN_INDEX_AGE=1

oldtime=0
# inotifywait --monitor \
#   --recursive \
#   --event close_write \
#   --timefmt '%s' --format '%T %w %f' \
#   "$MAILDIR_ROOT" |
#   while read newtime dir file; do
#     echo $dir $file
#     if [ $((newtime - oldtime)) -ge $MIN_INDEX_AGE ]; then
#       echo /usr/bin/notmuch new 2>&1
#     fi
#     oldtime=$newtime
#   done

fswatch --recursive \
  -e "${MAILDIR_ROOT}/.notmuch/.*" \
  -t --format-time '%s' \
  "$MAILDIR_ROOT" |
  while read newtime file; do
    if [ $((newtime - oldtime)) -ge $MIN_INDEX_AGE ]; then
      notmuch new 2>&1
    fi
    oldtime=$newtime
  done
