set -e

finish() {
  cd - >/dev/null
}

trap finish EXIT

cd ~/local/src/vim

compile() {
  git merge
  configure_vim.sh
  make -j 4
  echo "vim should dynamically link to the system-provided Ruby lib, or ruby will segfault"
  echo "If desired, test with ':ruby 1' inside vim"
  echo "Checking with otool -L src/vim | grep Rub; ls -l src/vim"
  echo
  # otool -L src/vim | grep Rub; ls -l src/vim
  printf "make install (Y/n)? "
  read -r answer
  answer=${answer:-Y}
  case $answer in
    [yY]* ) make install;;
    [nN]* ) exit;;
    *) ;;
  esac
}

if git fetch; then
  git log --oneline --graph --all --decorate master..origin/master
  # http://alvinalexander.com/linux-unix/shell-script-how-prompt-read-user-input-bash
  printf "Continue (Y/n)? "
  read -r answer
  answer=${answer:-Y}
  case $answer in
    [yY]* ) compile;;
    [nN]* ) exit;;
    *) ;;
  esac
else
  echo git fetch failed. Fix this and try again.
  exit 1
fi
