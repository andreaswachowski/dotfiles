# vi: ts=2 sw=2 expandtab
DOTFILES=~/dotfiles # Assume dotfiles is checked out here
if [ ! -d "$DOTFILES" ]; then
  echo Dotfiles not found at $DOTFILES. Set this variable correctly, then continue. Aborting.
  exit 1
fi

DOTFILESBACKUP=~/.dotfiles_setup_backup.$(date +%Y%m%d_%H%M%S)

mkdir $DOTFILESBACKUP

function link {
  SOURCE=$1
  TARGET=$2
  SKIP="false"
  if [ -e "$TARGET" ]; then
    if [ ! -L "$TARGET" -o "$(readlink $TARGET)" != "$SOURCE" ]; then
      echo Found $TARGET, moving to $DOTFILESBACKUP
      mv $TARGET $DOTFILESBACKUP/$(basename $TARGET)
      if [ $? -ne 0 ]; then
        echo Could not move $TARGET, will not execute ln -s $SOURCE $TARGET
        SKIP="true"
      fi
    else
      echo Symbolic link from $SOURCE to $TARGET already in place, skipping ...
      SKIP="true"
    fi
  fi

  if [ "$SKIP" = "false" ]; then
    echo ln -s $SOURCE $TARGET ...
    ln -s $SOURCE $TARGET
  fi
}


link $DOTFILES/.vim ~/.vim
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
  # YouCompleteMe is not necessarily configured for all machines on which 
  # this script runs
  if [ -d ~/.vim/bundle/YouCompleteMe ]; then
    cd ~/.vim/bundle/YouCompleteMe
    ./install.sh --clang-completer
  fi
fi

for dotfile in vimrc tmuxinator tmux.conf
do
  link $DOTFILES/$dotfile ~/.$dotfile
done

if [ ! "$(ls -A $DOTFILESBACKUP)" ]; then  # Directory empty
  rmdir $DOTFILESBACKUP
fi
