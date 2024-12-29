#!/usr/bin/env bash
#
# https://gist.github.com/trev-dev/01a5fbf28127e0af08657bc6e332b32b

set -e

check_available() {
  if ! command -v "$1" &>/dev/null; then
    echo "Error: $1 is not available. ${2:-}" >&2
    exit 1
  fi
}

# Check for required commands
check_available mbsync "brew install isync"
check_available mmkdir "Download and make/make install https://github.com/leahneukirchen/mblaze"
check_available mrefile "Download and make/make install https://github.com/leahneukirchen/mblaze"
check_available notmuch "brew install notmuch"

mbsync mailbox

ARCHIVE_PATH="$HOME/Mail/mailbox.org/Archive"
for email in "$ARCHIVE_PATH/"{new,cur}/*; do
  if [[ -r "$email" ]]; then
    # Extract the year from the email's Date header
    year=$(grep -m1 '^Date:' "$email" | awk '{print $5}')
    if [[ -n "$year" ]] && [[ "$year" =~ ^20.* ]]; then
      mmkdir "$ARCHIVE_PATH.$year"
      mrefile -v "$email" "$ARCHIVE_PATH.$year/cur"
    else
      echo Cannot move "$email"
    fi
  fi
done

# mbsync gmail
notmuch new
notmuch tag --batch --input="${HOME}/.config/mutt/tagfile.notmuch"
