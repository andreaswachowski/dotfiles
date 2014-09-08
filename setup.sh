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
    echo Found $TARGET, moving to $DOTFILESBACKUP
    mv $TARGET $DOTFILESBACKUP/$(basename $TARGET)
    if [ $? -ne 0 ]; then
      echo Could not move $TARGET, will not execute ln -s $SOURCE $TARGET
      SKIP="true"
    fi
  fi

  if [ "$SKIP" = "false" ]; then
    echo ln -s $SOURCE $TARGET ...
    ln -s $SOURCE $TARGET
  fi
}


link $DOTFILES/.vim ~/.vim
link $DOTFILES/vimrc ~/.vimrc
