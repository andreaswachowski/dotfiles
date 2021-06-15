# vi: filetype=sh
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
export EDITOR=vim
export VISUAL=vim # crontab -e on qnap depends on VISUAL and apparently does not read EDITOR
export LESS="-erFX $LESS" # "-FX" make less exit if output is <1page. Handy for git log
# -erX was necessary for color since around git 2.14.1 (but git itself might not be the reason)
# Also see http://eigenjoy.com/2008/07/23/mac-os-x-color-showing-escwhatever-for-git-diff-colors-and-more/

# -------------------------------------------------------------------------
# PATH
PATH="$HOME/.cargo/bin:\
$HOME/.yarn/bin:\
$HOME/.rvm/bin:\
$HOME/Documents/git_projects/csslint/dist:\
$HOME/bin:\
$HOME/local/bin:\
$HOME/dotfiles/local/bin:\
$HOME/dotfiles/os/bin:\
$HOME/dotfiles/bin:\
$HOME/dotfiles/bin/remarkable/host:\
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
OS_SPECIFIC_PROFILE=~/.config/sh/profile.os.$(uname -s)
if [ -f $OS_SPECIFIC_PROFILE ]; then
  # shellcheck source=/dev/null
  . $OS_SPECIFIC_PROFILE
fi

HOST_SPECIFIC_PROFILE=~/.config/sh/profile.host.$(uname -n)
if [ -f $HOST_SPECIFIC_PROFILE ]; then
  # shellcheck source=/dev/null
  . $HOST_SPECIFIC_PROFILE
fi

# shellcheck source=/dev/null
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# If nvm installed with Homebrew, look in /usr/local:
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
