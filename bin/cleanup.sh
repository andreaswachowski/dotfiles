#!/bin/bash
# vi: tw=0

# Cleanup vim swap files
VIMSWAPDIR=$HOME/tmp/vim
find $VIMSWAPDIR -type d -empty -delete
