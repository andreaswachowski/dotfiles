#!/bin/sh
# https://www.youtube.com/watch?v=hZS96dwKvt0

if [ $# -ne 1 ]; then
    echo "$(basename "$0") <playground-name>"
    exit 1
fi

PLAYGROUND=$1

for file in "$PLAYGROUND" "$PLAYGROUND-fake-remote"; do
    if [ -e "$file" ]; then
        echo "$file does already exist, aborting."
        exit 1
    fi
done

git init "$PLAYGROUND"
git init --bare "$PLAYGROUND-fake-remote"
cd "$PLAYGROUND" || exit
git remote add origin "../$PLAYGROUND-fake-remote"

echo With the first push, use "git push -u origin main" to set up the tracking branch
