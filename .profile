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

path_append() {
  case ":$PATH:" in
  *:"$1":*) ;;          # already there → do nothing
  *) PATH="$PATH:$1" ;; # not there → append
  esac
}

path_prepend() {
  case ":$PATH:" in
  *:"$1":*) ;;          # already there → do nothing
  *) PATH="$1:$PATH" ;; # not there → prepend
  esac
}

path_prepend "/opt/homebrew/opt/gnu-tar/libexec/gnubin"
path_prepend "$HOME/dotfiles/bin/remarkable/host"
path_prepend "$HOME/dotfiles/bin"
path_prepend "$HOME/dotfiles/os/bin"
path_prepend "$HOME/dotfiles/local/bin"
path_prepend "$HOME/local/bin"
path_prepend "$HOME/bin"
path_prepend "$HOME/Documents/git_projects/csslint/dist"
path_prepend "$HOME/.yarn/bin"
path_prepend "$HOME/.cargo/bin"

export PATH

if [ -z "$BASH" ]; then
  if [ "$(id -u)" -eq 0 ]; then
    PS1='[\w] # '
  else
    PS1='[\w] $ '
  fi
fi

# ---------------------------------------------------------------------------
#
# setup ssh-agent
#
# http://mah.everybody.org/docs/ssh

# set environment variables if user's agent already exists
# the sed call at the end just in case someone (QNAP!) has aliased ls to ls -F
[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(ls -ltr /tmp/ssh-*/agent.* 2>/dev/null | grep $(whoami) | awk '{print $9}' | sed 's/=$//')
if [ $(echo "$SSH_AUTH_SOCK" | wc -l) -gt 1 ]; then
  echo Warning, more than one ssh agent socket found, using first: echo $SSH_AUTH_SOCK
  SSH_AUTH_SOCK=$(echo "$SSH_AUTH_SOCK" | head -1)
fi
[ -z "$SSH_AGENT_PID" -a "$(echo $SSH_AUTH_SOCK | cut -d. -f2)" ] && SSH_AGENT_PID=$(($(echo $SSH_AUTH_SOCK | cut -d. -f2) + 1))
[ -n "$SSH_AUTH_SOCK" ] && export SSH_AUTH_SOCK
[ -n "$SSH_AGENT_PID" ] && export SSH_AGENT_PID

# start agent if necessary
# if [ -z "$SSH_AGENT_PID" ] && [ -z "$SSH_TTY" ]; then  # if no agent & not in ssh
if [ -z "$SSH_AGENT_PID" ]; then # if no agent
  eval $(ssh-agent -s) >/dev/null
fi

# setup addition of keys when needed
if [ -z "$SSH_TTY" ]; then # if not using ssh
  ssh-add -l >/dev/null    # check for keys
  if [ $? -ne 0 ]; then
    alias ssh='ssh-add -l > /dev/null || ssh-add && unalias ssh ; ssh'
    if [ -f "/usr/lib/ssh/x11-ssh-askpass" ]; then
      SSH_ASKPASS="/usr/lib/ssh/x11-ssh-askpass"
      export SSH_ASKPASS
    fi
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
