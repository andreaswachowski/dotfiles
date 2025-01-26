#!/usr/bin/env bash

DICT_URL="https://cgit.freedesktop.org/libreoffice/dictionaries/plain/dictionaries"
LANGS=("de_DE" "en_US" "fr_FR")

for LANG in "${LANGS[@]}"; do
  curl -O "$DICT_URL/${LANG:0:2}/${LANG}_frami.dic"
  curl -O "$DICT_URL/${LANG:0:2}/${LANG}_frami.aff"
  mkdir -p ~/.config/vale/config/styles/dictionaries
  mv "${LANG}_frami.dic" ~/.config/vale/styles/config/dictionaries/"$LANG".dic
  mv "${LANG}_frami.aff" ~/.config/vale/styles/config/dictionaries/"$LANG".aff
done
