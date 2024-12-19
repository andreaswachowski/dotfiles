#!/usr/bin/env bash
#
# https://gist.github.com/trev-dev/01a5fbf28127e0af08657bc6e332b32b

mbsync mailbox

ARCHIVE_PATH="$HOME/Mail/mailbox.org/Archive"
for email in "$ARCHIVE_PATH/"{new,cur}/*; do
  if [[ -r "$email" ]]; then
    # Extract the year from the email's Date header
    year=$(grep -m1 '^Date:' "$email" | awk '{print $5}')
    if [[ -n "$year" ]] && [[ "$year" =~ ^20.* ]]; then
      mkdir -p "$ARCHIVE_PATH.$year/"{cur,new,tmp}
      mv "$email" "$ARCHIVE_PATH.$year/cur"
    else
      echo Cannot move $email
    fi
  fi
done

# mbsync gmail
notmuch new
notmuch tag --batch --input="${HOME}/.config/mutt/tagfile.notmuch"
