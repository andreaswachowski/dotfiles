#!/usr/bin/env bash
# Move notmuch-deleted messages to Trash Maildir and sync to IMAP.
# Messages tagged 'trash' are already hidden from notmuch searches via
# exclude_tags, but stay physically in their source folder until this runs.
# Mirrors notmuch-archive.sh: copy to Trash, mark source with Maildir :2,...T
# flag (\Deleted), then let mbsync expunge and upload.
#
# Usage: notmuch-purge.sh [-n|--dry-run]

set -euo pipefail

DRY_RUN=false
[[ "${1:-}" == "-n" || "${1:-}" == "--dry-run" ]] && DRY_RUN=true

TRASH_DIR="$HOME/Mail/mailbox.org/Trash"

ensure_seen_flag() {
  local name="$1"
  if [[ "$name" != *:2,* ]]; then
    echo "${name}:2,S"
  elif [[ "$name" != *:2,*S* ]]; then
    local prefix="${name%:2,*}"
    local flags="${name##*:2,}"
    flags=$(printf '%s' "${flags}S" | grep -o . | sort | tr -d '\n')
    echo "${prefix}:2,${flags}"
  else
    echo "$name"
  fi
}

add_trashed_flag() {
  local file="$1"
  local dir basename prefix flags
  dir=$(dirname "$file")
  basename=$(basename "$file")
  if [[ "$basename" == *:2,* ]]; then
    prefix="${basename%:2,*}"
    flags="${basename##*:2,}"
    if [[ "$flags" != *T ]]; then
      flags=$(printf '%s' "${flags}T" | grep -o . | sort | tr -d '\n')
      mv -- "$file" "$dir/${prefix}:2,${flags}"
    fi
  else
    mv -- "$file" "$dir/${basename}:2,T"
  fi
}

count=0
while IFS= read -r file; do
  [[ -f "$file" ]] || continue
  # if the script is run twice before mbsync cleans up, the T-flagged source
  # (:2,...T) is still in INBOX and still matches the notmuch query. A second
  # run would create an extra copy in the destination. Guard against this by
  # skipping files whose name already contains the T flag.
  # Also, the Maildir flag set is D F P R S T and the spec requires them to be
  # stored in ascending ASCII order. T (ASCII 84) is the highest value of all
  # defined flags, so in any conforming filename T is always the last character.
  [[ "$(basename "$file")" == *:2,*T ]] && continue

  # Strip ,U=<uid> from the destination filename (avoids UID range errors on
  # upload). Also force the S (Seen) flag so the copy never appears as old (O)
  # in neomutt — the notmuch 'unread' tag is the authoritative read-state for
  # this workflow; the Maildir flag in the archive is display-only.
  dest_name="$(basename "$file" | sed -E 's/,U=[0-9]+//')"
  dest_name=$(ensure_seen_flag "$dest_name")
  if $DRY_RUN; then
    echo "Would move to Trash: $file → $TRASH_DIR/cur/$dest_name"
  else
    mmkdir "$TRASH_DIR"
    # cp is intentional. The strategy requires two files to coexist temporarily:
    # 1. The destination copy (in Archive.<year>/cur/ or Trash/cur/) so that mbsync uploads it to IMAP.
    # 2. The source, renamed with :2,...T so that mbsync sees \Deleted and expunges it from IMAP.
    #
    # mrefile is a move — it removes the source immediately. Without a T-flagged source, mbsync
    # (without Remove Far) would re-download the message from IMAP on the next sync. So cp +
    # add_trashed_flag is the right choice for the current mbsync configuration.
    tmp_file="$TRASH_DIR/tmp/$dest_name"
    cp -- "$file" "$tmp_file"
    mv -- "$tmp_file" "$TRASH_DIR/cur/$dest_name"
    add_trashed_flag "$file"
  fi
  ((count++)) || true
done < <(notmuch search --output=files 'tag:trash and not folder:mailbox.org/Trash')

if ((count > 0)); then
  if $DRY_RUN; then
    echo "Would move $count message(s) to Trash (dry run — no changes made)."
  else
    echo "Moved $count message(s) to Trash; syncing..."
    mbsync mailbox
    notmuch new
  fi
else
  echo "Nothing to purge."
fi
