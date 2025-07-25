#!/bin/sh

finish() {
  rv=$?
  cd - >/dev/null
  exit $rv
}

# https://github.blog/changelog/2025-06-03-releases-now-expose-digests-for-release-assets/
OS=$(uname -s)
if [ "$OS" = "Linux" ]; then
  DIRECTORY=nvim-linux-x86_64
elif [ "$OS" = "Darwin" ]; then
  ARCH=$(uname -m)
  DIRECTORY=nvim-macos-$ARCH
else
  echo Unknown OS "$OS", aborting.
  exit 1
fi

trap finish EXIT INT TERM

echo Before update:
ls -l ~/local/"$DIRECTORY"/bin/nvim
nvim --version

cd ~/local || exit 1

FILENAME=$DIRECTORY.tar.gz
SHA256=$FILENAME.sha256

curl -L "https://github.com/neovim/neovim/releases/download/nightly/$FILENAME" >"$FILENAME"
# curl -L "https://github.com/neovim/neovim/releases/download/nightly/$SHA256" >"$SHA256"

# sha256sum --check "$SHA256" || exit 1

tar zxf "$FILENAME"

echo After update:
ls -l ~/local/"$DIRECTORY"/bin/nvim
nvim --version
cd - || exit 1
