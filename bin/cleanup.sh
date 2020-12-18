#!/bin/bash
# vi: tw=0


VIMSWAPDIR=$HOME/tmp/vim
REGEX="$(echo $(pgrep vim) "$VIMSWAPDIR" | tr ' ' '|')"

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


find $FIND_OPTS -type d ! -regex ".*($REGEX)" -delete 2> >(grep -v 'relative path potentially not safe' >&2)
