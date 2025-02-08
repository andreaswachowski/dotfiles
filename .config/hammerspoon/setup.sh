#!/bin/sh

if [ ! -d ~/.hammerspoon ]; then
  mkdir -f ~/.hammerspoon

  for file in init.lua .luarc.json; do
    if [ ! -f ~/.hammerspoon/$file ]; then
      ln -s $file ~/.hammerspoon/$file
    fi
  done
fi
