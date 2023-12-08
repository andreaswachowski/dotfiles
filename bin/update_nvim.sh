#!/bin/sh

finish() {
  rv=$?
  cd - >/dev/null
  exit $rv
}

trap finish EXIT INT TERM

echo Before update:
ls -l ~/local/nvim-macos/bin/nvim
nvim --version

cd ~/local || exit 1

curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz >nvim-macos.tar.gz
curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz.sha256sum >nvim-macos.tar.gz.sha256sum

sha256sum --check <nvim-macos.tar.gz.sha256sum || exit 1

tar zxf nvim-macos.tar.gz

echo After update:
ls -l ~/local/nvim-macos/bin/nvim
nvim --version
cd - || exit 1
