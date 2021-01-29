# vi: ts=2 sw=2 expandtab
ScriptName=$(basename $0)

function displayUsageScreen {
  cat << HERE
Usage: $ScriptName [-h|-v]

Initializes dotfiles.

Options:
  -h : Displays this screen
  -v : Verbose mode.
HERE
}

abort() {
  >&2 echo "$1. Aborting."
  exit 1
}

execute() {
	DOTFILES=$DOTFILES $1
}

execute_if_available() {
  [ -x "$1" ] && $1
}

log() {
  echo "*** $*"
}

is_available() {
  command -v "$1" >/dev/null 
}

detect_os() {
  log "Detecting OS ..."
  case $(uname) in
    Linux)
      OS=linux
      ;;
    Darwin)
      OS=Darwin
      ;;
    *)
      abort "Unknown OS $(uname)"
  esac
  log "OS=$OS"
}

abort_detect_distributor_id() {
  abort "Cannot determine distributor ID ($1)"
}

detect_distributor_id() {
  log Detecting distribution ...
  case $(uname) in
    Linux)
      if is_available lsb_release; then
        DISTRIBUTOR_ID=$(lsb_release --all | grep 'Distributor ID' | sed 's/.*:\t//')
      else
        OS_ID_AS_PER_ETC_RELEASE=$(grep '^ID' /etc/*-release | cut -d= -f2)
        case $OS_ID_AS_PER_ETC_RELEASE in
          qts)
            DISTRIBUTOR_ID=QNAP
            ;;
          *)
            abort_detect_distributor_id "no suitable ID found in /etc/*-release"
        esac
      fi
      ;;
    Darwin)
      DISTRIBUTOR_ID=Apple
      ;;
    *)
      abort_detect_distributor_id "unknown OS \"$(uname)\""
  esac
  log "DISTRIBUTOR_ID=$DISTRIBUTOR_ID"
}

determine_package_installer() {
  log "Determining package installer ..."
  PACKAGE_INSTALLER_DEFINITION_FILE="$SETUP_HELPER_DIR/by_distributor_id/$DISTRIBUTOR_ID/package_manager"
  if [ -f "$PACKAGE_INSTALLER_DEFINITION_FILE" ]; then
    PACKAGE_INSTALLER=$(cat "$PACKAGE_INSTALLER_DEFINITION_FILE")
  else
    abort "Don't know package installer for distros by \"$DISTRIBUTOR_ID\" (cannot find \"$PACKAGE_INSTALLER_DEFINITION_FILE\")"
  fi
  log "PACKAGE_INSTALLER=$PACKAGE_INSTALLER"
}

ensure_package_installer_availability() {
  PACKAGE_INSTALLER_FULL_PATH=$(command -v "$PACKAGE_INSTALLER")
  is_available "$PACKAGE_INSTALLER" || "$SETUP_HELPER_DIR/by_package_manager/$PACKAGE_INSTALLER/install_self"
  PACKAGE_INSTALLER_FULL_PATH=$(command -v "$PACKAGE_INSTALLER")
  [ -n "$PACKAGE_INSTALLER_FULL_PATH" ] || abort "Failed to initialize $PACKAGE_INSTALLER"
}

prepare_package_installer() {
  ensure_package_installer_availability
  execute_if_available "$SETUP_HELPER_DIR/by_package_manager/$PACKAGE_INSTALLER/update_packages"
}

configure_install_cmd() {
  log "Configuring install command ..."
  INSTALL_CMD_FILE=$SETUP_HELPER_DIR/by_package_manager/$PACKAGE_INSTALLER/install_cmd
  if [ -f "$INSTALL_CMD_FILE" ]; then
    INSTALL_CMD=$(cat "$SETUP_HELPER_DIR/by_package_manager/$PACKAGE_INSTALLER/install_cmd")
  else
    abort "Cannot configure package-install command (cannot find \"$INSTALL_CMD_FILE\")"
  fi
  log "INSTALL_CMD=$INSTALL_CMD"
}

detect_window_manager() {
  log "Detecting window manager ..."
  if [ $OS = "Darwin" ]; then
    WINDOW_MANAGER="Mac OS";
  else
    is_available wmctrl || $INSTALL_CMD wmctrl # fine if installation fails
    is_available wmctrl && WINDOW_MANAGER=$(wmctrl -m | grep ^Name | sed 's/Name: //')
    # still not assigned? wmctrl not installable, possibly a server system
    # like QTS
    [ -z "$WINDOW_MANAGER" ] && WINDOW_MANAGER="N/A"
  fi;
  log "WINDOW_MANAGER=$WINDOW_MANAGER"
}

window_manager_to_directory() {
	case "$1" in
		KWin) echo kde
			;;
		GNOME\ Shell) echo gnome
			;;
		Mac\ OS) echo mac_os
			;;
		N/A) echo none
			;;
		*) echo unknown
	esac
}

setup_basics() {
  detect_os
  detect_distributor_id
  determine_package_installer
  prepare_package_installer
  configure_install_cmd
  detect_window_manager
}

install_fundamentals() {
  log "Installing fundamental packages ..."
  case $PACKAGE_INSTALLER in
    brew) brew bundle --file="$DOTFILES/os_specific/Darwin/dots/Brewfile"
      ;;
    *) BASIC_PACKAGES_FILE="$SETUP_HELPER_DIR/by_distributor_id/$DISTRIBUTOR_ID/basic_packages"
      if [ -f "$BASIC_PACKAGES_FILE" ]; then
        BASIC_PACKAGES=$(cat $SETUP_HELPER_DIR/by_distributor_id/$DISTRIBUTOR_ID/basic_packages)
        $INSTALL_CMD $BASIC_PACKAGES
      fi
  esac
}

# --- process options (example)
while getopts ":hv" OPT
do
    case "$OPT" in
    h)  displayUsageScreen
        exit
        ;;

    v)  VERBOSE="true"
        ;;

    :)  >&2 echo "Incorrect Syntax: -${OPTARG} needs argument. (Use -h for help)"
        displayUsageScreen
        exit 1
        ;;

    \?) >&2 echo "Incorrect Syntax: -${OPTARG} bad option. (Use -h for help)"
        exit 1
        ;;
    esac
done

shift $(expr $OPTIND - 1)

DOTFILES=~/dotfiles # Assume dotfiles is checked out here

[ -d "$DOTFILES" ] || \
  abort "Dotfiles not found at $DOTFILES. Set this variable correctly, then continue"

SETUP_HELPER_DIR=$DOTFILES/setup_helpers

setup_basics
install_fundamentals

WINDOW_MANAGER_DIR=$SETUP_HELPER_DIR/by_window_manager/$(window_manager_to_directory "$WINDOW_MANAGER")
if [ -d "$WINDOW_MANAGER_DIR" ]; then
  log "Executing window-manager specific scripts from $WINDOW_MANAGER_DIR ..."
  for script in "$WINDOW_MANAGER_DIR"/*
  do
    execute "$WINDOW_MANAGER_DIR/$script"
  done
else
  log "No window-manager specific scripts found (looked in $WINDOW_MANAGER_DIR) ..."
fi

gitfallback() {
  echo "git not found. skipping git $*"
}

GITCMD=$(command -v git)
if [ -z "$GITCMD" ]; then
  # on QTS, PATH might not yet be set appropriately, so we hard-check against it
  if [ -f /opt/bin/git ]; then
    GITCMD=/opt/bin/git
  else
    GITCMD=gitfallback
  fi
fi

cd $DOTFILES
$GITCMD submodule init
$GITCMD submodule update
cd -

DOTFILESBACKUP=~/.dotfiles_setup_backup.$(date +%Y%m%d_%H%M%S)

mkdir "$DOTFILESBACKUP"

function link {
  SOURCE=$1
  TARGET=$2
  SKIP="false"
  # Testing explicitly for the symbolic link captures
  # dangling symbolic links
  if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    if [ ! -L "$TARGET" ] || [ "$(readlink "$TARGET" 2>/dev/null)" != "$SOURCE" ]; then
      [ "$VERBOSE" ] && echo "Found $TARGET, moving to $DOTFILESBACKUP"
      mv "$TARGET" "$DOTFILESBACKUP/$(basename "$TARGET")"
      if [ $? -ne 0 ]; then
        >&2 echo "Could not move $TARGET, will not execute ln -s $SOURCE $TARGET"
        SKIP="true"
      fi
    else
      [ "$VERBOSE" ] && echo "Symbolic link from $SOURCE to $TARGET already in place, skipping ..."
      SKIP="true"
    fi
  fi

  if [ "$SKIP" = "false" ]; then
    echo "ln -s $SOURCE $TARGET ..."
    ln -s "$SOURCE" "$TARGET"
  fi
}

# Setup terminfo entries
# https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/
which tic 2>&1 >/dev/null
if [ $? -eq 0 ]; then
  for terminfo_record in share/terminfo/*.terminfo
  do
    tic $terminfo_record
  done
fi

for dotfile in $(ls $DOTFILES/dots | grep -v rvm)
do
  link "$DOTFILES/dots/$dotfile" "$HOME/.$dotfile"
done

if [ -f "$HOME/.rvm/gemsets/global.gems" ]; then
  diff "$HOME/.rvm/gemsets/global.gems" "$DOTFILES/dots/rvm/gemsets/global.gems" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo Consider using the following changes in .rvm/gemsets/global.gems:
    diff -p $HOME/.rvm/gemsets/global.gems $DOTFILES/dots/rvm/gemsets/global.gems
  fi
fi

for nodotfile in $(ls $DOTFILES/nodots)
do
  link "$DOTFILES/dots/$nodotfile" "$HOME/$nodotfile"
done

for setup in $(ls $DOTFILES/setups 2>/dev/null)
do
  echo "Executing setup for $setup ..."
  "$DOTFILES/setups/$setup"
done

if [ -f $DOTFILES/os/setup.sh ]; then
  echo Executing os-specific setup ...
  $DOTFILES/os/setup.sh
fi

cat <<EOF
1) csslint:
git clone git@github.com:andreaswachowski/csslint.git
git co -b add-svg-properties
npm install
grunt release
ln -s dist/csslint dist/cli.js
EOF

if [ ! "$(ls -A "$DOTFILESBACKUP")" ]; then  # Directory empty
  rmdir "$DOTFILESBACKUP"
fi
