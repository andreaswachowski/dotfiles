#!/bin/sh

# https://superuser.com/questions/380772/removing-ansi-color-codes-from-text-stream

SED="sed"

if [ "$(uname)" = Darwin ]; then
  # GNU Sed required
  SED=gsed

  if ! which gsed >/dev/null; then
    echo 'GNU Sed required, install with "brew install gsed"'
    exit 1
  fi
fi

# \x1b\[ → ESC + [ (start of CSI)
# [0-9;?]* → optional parameters (digits, ;, ?)
# [A-Za-z] → final byte
$SED -e 's/\x1b\[[0-9;?]*[A-Za-z]//g' "$1"
