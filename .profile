# vi: filetype=sh
#
# shellcheck shell=sh disable=SC1090 disable=SC1091
# From http://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile/183980#183980
# ~/.profile is the place to put stuff that applies to your whole session,
# such as programs that you want to start when you log in (but not
# graphical programs, they go into a different file), and
# environment variable definitions.

# fix for QNAP devices - source this before appending any other PATH settings

# this will be removable after decommissioning the other NASs
if [ -f /Apps/opt/etc/profile ]; then
  # shellcheck source=/dev/null
  . /Apps/opt/etc/profile
fi

# for the new NAS
if [ -f /opt/etc/profile ]; then
  # shellcheck source=/dev/null
  . /opt/etc/profile
fi

set -o vi
export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export VISUAL=nvim # crontab -e on qnap depends on VISUAL and apparently does not read EDITOR

# -------------------------------------------------------------------------
# PATH
PATH="$HOME/.cargo/bin:\
$HOME/.yarn/bin:\
$HOME/Documents/git_projects/csslint/dist:\
$HOME/bin:\
$HOME/local/bin:\
$HOME/dotfiles/local/bin:\
$HOME/dotfiles/os/bin:\
$HOME/dotfiles/bin:\
$HOME/dotfiles/bin/remarkable/host:\
/opt/homebrew/opt/gnu-tar/libexec/gnubin:\
$PATH"
export PATH

if [ -z "$BASH" ]; then
  if [ "$(id -u)" -eq 0 ]; then
    PS1='[\w] # '
  else
    PS1='[\w] $ '
  fi
fi

# -------------------------------------------------------------------------
profile_os="${HOME}/.config/sh/profile-os"
if [ -r "$profile_os" ]; then
  . "$profile_os"
fi

profile_distro="${HOME}/.config/sh/profile-distro"
if [ -r "$profile_distro" ]; then
  . "$profile_distro"
fi

profile_local="$HOME/.config/sh/profile-local"
if [ -r "$profile_local" ]; then
  . "$profile_local"
fi

export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
export SOPS_AGE_RECIPIENTS="age1xnpatet4zu07tqyr7yzcvedw02au4gjp4rmqlfx0dax9w5xfjqpqpgvk88"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                    # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# If nvm installed with Homebrew, look in /usr/local:
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
