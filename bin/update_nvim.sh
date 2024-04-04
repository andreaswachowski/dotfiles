#!/bin/sh

finish() {
  rv=$?
  cd - >/dev/null
  exit $rv
}

ARCH=$(uname -m)

trap finish EXIT INT TERM

echo Before update:
ls -l ~/local/"nvim-macos-$ARCH"/bin/nvim
nvim --version

cd ~/local || exit 1

FILENAME=nvim-macos-$ARCH.tar.gz
SHA256=$FILENAME.sha256sum

curl -L "https://github.com/neovim/neovim/releases/download/nightly/$FILENAME" >"$FILENAME"
curl -L "https://github.com/neovim/neovim/releases/download/nightly/$SHA256" >"$SHA256"

sha256sum --check <"$SHA256" || exit 1

tar zxf "$FILENAME"

echo After update:
ls -l ~/local/"nvim-macos-$ARCH"/bin/nvim
nvim --version
cd - || exit 1
