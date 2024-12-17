#!/bin/bash
# vi: tw=0

FIND=$(command -v find)

VIMSWAPDIR=$HOME/tmp/vim
REGEX="$(echo $(pgrep vim) "$VIMSWAPDIR" | tr ' ' '|')"
USER=$(whoami)

DRY_RUN=false

while getopts "n" opt; do
  case $opt in
  n)
    DRY_RUN=true
    ;;
  *)
    echo "Usage: $0 [-n] (dry-run mode)"
    exit 1
    ;;
  esac
done

if [ "$DRY_RUN" = true ]; then
  ACTION="-print"
else
  ACTION="-delete"
fi

case $(uname) in
Linux)
  FIND_OPTS="$VIMSWAPDIR -regextype posix-extended"
  ;;
Darwin)
  FIND_OPTS="-E $VIMSWAPDIR"
  ;;
*)
  echo Unknown platform, aborting
  exit 1
  ;;
esac

# Cleanup vim swap files
# see http://stackoverflow.com/questions/762348/how-can-i-exclude-all-permission-denied-messages-from-find
# for a discussion on the error output redirection

$FIND $FIND_OPTS -type f -user $USER ! -regex ".*($REGEX)" $ACTION 2> >(grep -v 'Permission denied' >&2)
$FIND $FIND_OPTS -type d -user $USER ! -regex ".*($REGEX)" $ACTION 2> >(grep -v 'Permission denied' >&2)

$FIND $HOME/{Downloads,tmp} -mindepth 1 \
  -mount -mtime +60 ! -name '$HOME/tmp/vim/*' $ACTION 2> >(grep -v 'Permission denied' >&2)
$FIND $HOME/Desktop -mindepth 1 -type f \
  \( -name 'Screen Shot *' -o -name 'Screenshot *' -o -name 'Screen Rec*' -o -name '*.png' \) \
  -mount -mtime +60 $ACTION
