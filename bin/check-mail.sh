#!/usr/bin/env bash
#
# https://gist.github.com/trev-dev/01a5fbf28127e0af08657bc6e332b32b

mbsync mailbox
# mbsync gmail
notmuch new
notmuch tag --batch --input="${HOME}/.config/mutt/tagfile.notmuch"
