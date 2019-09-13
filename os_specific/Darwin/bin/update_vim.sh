set -e

finish() {
  rv=$?
  cd - >/dev/null
  exit $rv
}

trap finish EXIT INT TERM

cd ~/local/src/vim

compile() {
  git merge
  configure_vim.sh
  make -j 4
  echo "Check ruby inside vim: vim --cmd 'ruby 1' --cmd 'q!'"
  if ! vim --cmd 'ruby 1' --cmd 'q!'; then
    echo "ruby errors inside vim, exiting (is the *system-provided* ruby library used?)."
  fi
  if [ ! -f src/vim ]; then
    echo "No vim executable produced, exiting."
  fi
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
