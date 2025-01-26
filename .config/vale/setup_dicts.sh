#!/usr/bin/env bash

DICT_URL="https://cgit.freedesktop.org/libreoffice/dictionaries/tree"
DICT_DIR=~/.config/vale/styles/config/dictionaries

declare -A dicts=(
  ["de/de_DE_frami"]="de_DE"
  ["en/en_US"]="en_US"
  ["fr_FR/fr"]="fr_FR"
)
if [ "$(uname -s)" = "Darwin" ]; then
  FILEOPT=-I
else
  FILEOPT=-i
fi

if [ ! -d $DICT_DIR ]; then
  mkdir -p $DICT_DIR
fi

for dict in "${!dicts[@]}"; do
  for ext in dic aff; do
    curl -O "$DICT_URL/$dict.${ext}"
    src_file="${dict##*/}.${ext}"
    dest_file="$DICT_DIR/${dicts[${dict}]}.${ext}"
    if file $FILEOPT "$src_file" | grep 8859 >/dev/null; then
      # The German de_DE_frami.aff is in ISO-8859-1, and unless its UTF-8,
      # vale bails while compiling the expression "[^aeiouhlräüö]lig".
      echo "Converting $src_file from ISO-8859-1 to UTF-8"
      iconv -f iso-8859-1 -t utf-8 "$src_file" >"$dest_file"
      rm "$src_file"
    else
      mv "$src_file" "$dest_file"
    fi
  done
done
