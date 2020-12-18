#!/bin/bash
# vi: tw=0

# Cleanup vim swap files
VIMSWAPDIR=$HOME/tmp/vim
# see http://stackoverflow.com/questions/762348/how-can-i-exclude-all-permission-denied-messages-from-find
# for a discussion on the error output redirection
VIM_PIDS=$(ps -c | grep vim | cut -f1 -d' ' | paste -sd "|" -)

find -E "$VIMSWAPDIR" -type d ! -regex ".*($VIM_PIDS|$VIMSWAPDIR)" -delete 2> >(grep -v 'relative path potentially not safe' >&2)
