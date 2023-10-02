#!/bin/sh

if [ "$(uname -s)" != "Darwin" ]; then
    echo This is a MacOS only script. Use mkext4 on Linux. Aborting.
    exit 1
fi

mkfsexe="$(brew --prefix e2fsprogs)"/sbin/mkfs.ext4
if [ ! -f "$mkfsexe" ]; then
    echo "$mkfsexe not found. Aborting."
    exit 1
fi

if [ -z "$1" ]; then
    echo Usage: "$(basename "$0") /dev/disk999s000 (USB device)"
    exit 1
fi

USB_DEVICE=$1

sudo "$(brew --prefix e2fsprogs)"/sbin/mkfs.ext4 /dev/"$USB_DEVICE"
