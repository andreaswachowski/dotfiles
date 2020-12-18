#!/bin/bash
# vi: tw=0

PLATFORM=$(uname)

case $PLATFORM in
    Linux)
        FIND_REGEX="-regextype posix-extended"
        ;;
    Darwin)
        FIND_REGEX="-E"
        ;;
    *)
        echo Unknown platform, aborting
        exit 1
        ;;
esac

# Cleanup vim swap files
VIMSWAPDIR=$HOME/tmp/vim
# see http://stackoverflow.com/questions/762348/how-can-i-exclude-all-permission-denied-messages-from-find
# for a discussion on the error output redirection

REGEX="$(echo $(pgrep vim) "$VIMSWAPDIR" | tr ' ' '|')"

find "$VIMSWAPDIR" -type d $FIND_REGEX ! -regex ".*($REGEX)" -delete 2> >(grep -v 'relative path potentially not safe' >&2)
