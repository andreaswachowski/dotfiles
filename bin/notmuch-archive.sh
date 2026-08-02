#!/usr/bin/env bash
# Physically archive INBOX messages that no longer have the 'inbox' notmuch tag.
# Safe to run repeatedly; already-archived messages won't match the query.
#
# Strategy: copy to Archive.<year>, mark original with Maildir :2,T (\Deleted)
# flag, then let mbsync expunge the deleted messages from IMAP INBOX and upload
# the Archive copies. Avoids re-download that would happen with a plain mrefile.
#
# Usage: notmuch-archive.sh [-n|--dry-run]

set -euo pipefail

DRY_RUN=false
[[ "${1:-}" == "-n" || "${1:-}" == "--dry-run" ]] && DRY_RUN=true

MAIL_ROOT="$HOME/Mail/mailbox.org"

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
  [[ "$(basename "$file")" == *:2,*T ]] && continue

  year=$(grep -m1 '^Date:' "$file" | grep -oE '\b(19|20)[0-9]{2}\b' | head -1)
  if [[ -z "$year" ]]; then
    echo "WARN: cannot determine year for $file — skipping" >&2
    continue
  fi

  archive_dir="$MAIL_ROOT/Archive.$year"
  # Strip ,U=<uid> from the destination filename (avoids UID range errors on
  # upload). Also force the S (Seen) flag so the copy never appears as old (O)
  # in neomutt — the notmuch 'unread' tag is the authoritative read-state for
  # this workflow; the Maildir flag in the archive is display-only.
  dest_name="$(basename "$file" | sed -E 's/,U=[0-9]+//')"
  dest_name=$(ensure_seen_flag "$dest_name")

  if $DRY_RUN; then
    echo "Would archive: $file → $archive_dir/cur/$dest_name"
  else
    mmkdir "$archive_dir"
    tmp_file="$archive_dir/tmp/$dest_name"
    cp -- "$file" "$tmp_file"
    mv -- "$tmp_file" "$archive_dir/cur/$dest_name"
    add_trashed_flag "$file"
  fi
  ((count++)) || true
done < <(notmuch search --output=files 'folder:mailbox.org/INBOX and not tag:inbox and not tag:trash')

if ((count > 0)); then
  if $DRY_RUN; then
    echo "Would archive $count message(s) (dry run — no changes made)."
  else
    echo "Archived $count message(s); syncing..."
    mbsync mailbox
    notmuch new
  fi
else
  echo "Nothing to archive."
fi
