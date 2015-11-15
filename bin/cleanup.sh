#!/bin/bash
# vi: tw=0

# Cleanup vim swap files
VIMSWAPDIR=$HOME/tmp/vim
# 2>/dev/null: ignore warning on relative dirs potentially unsafe
find $VIMSWAPDIR -type d -empty -delete 2>/dev/null
