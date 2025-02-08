#!/bin/sh

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"

if [ ! -d ~/.hammerspoon ]; then
  mkdir ~/.hammerspoon
fi

for file in init.lua .luarc.json; do
  if [ ! -f ~/.hammerspoon/$file ]; then
    ln -s "$SCRIPT_DIR/$file" ~/.hammerspoon/$file
  fi
done
