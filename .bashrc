# vi:filetype=bash
#
# shellcheck shell=bash disable=SC1090 disable=SC1091
# From http://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile/183980#183980 :
#
# ~/.bashrc is the place to put stuff that applies only to bash itself,
# such as alias and function definitions, shell options, and prompt settings.
# (You could also put key bindings there, but for bash they normally go into
#  ~/.inputrc.)

# Careful: bashrc might be sourced for non-interactive shells, in
# particular scp, see
# http://lists.gnu.org/archive/html/bug-bash/2012-06/msg00028.html
# scp breaks when it encounters output, so all echos etc. must be
# avoided, and explicitly only happen when in interactive mode
# https://www.reddit.com/r/openSUSE/comments/7u3050/why_does_opensuse_chose_to_source_homebashrc_in/
# https://bugzilla.opensuse.org/show_bug.cgi?id=1078124

[ -z "$PS1" ] && return

alias be="bundle exec"
alias k="kubectl"
alias kx="kubectx"
alias yvim='GIT_DIR=$HOME/.local/share/yadm/repo.git GIT_WORK_TREE=$HOME vim'
alias dc="docker-compose"
alias ag='echo "use rg instead (due to ag not using .ignore when in subdirectories, see issues 1251, 287. Also last release 3 years old.)"'
alias ti="vim ~/Documents/Dropbox/notes/todos/tickler.taskpaper"
alias rg="rg --hidden --max-columns 255 -F --glob '!.git'"
command -v nvim >/dev/null && alias vim="nvim"
command -v xdg-open >/dev/null && alias open="xdg-open"

# Prompt initialization
if [ "$(id -u)" -eq 0 ]; then
  PROMPT_CHAR="#"
else
  PROMPT_CHAR="$"
fi

if command -v git >/dev/null 2>&1; then
  . ~/.config/bash/git-prompt.sh
  export PS1='\u@\h:\w$(__git_ps1 "[%s]")\n$(date +'%H:%M:%S') $PROMPT_CHAR '
else
  export PS1='\h:\w$(date +'%H:%M:%S') $PROMPT_CHAR '
fi

[[ -r ~/.bash_functions ]] && source "$HOME/.bash_functions"

# See "I have [bash] history back to ~2003" on https://news.ycombinator.com/item?id=10162189
# (for a different take, see http://mywiki.wooledge.org/BashFAQ/088 )
# According to my initial test, and according to one tweet in the discussion, on OS X, it is necessary
# to create the directory first:
HISTDIR=${HOME}/.history/$(date -u +%Y/%m/)
if [ ! -d "$HISTDIR" ]; then
  mkdir -p "$HISTDIR"
fi
# When testing, remember that the history is only written on session *exit*
# (see http://stackoverflow.com/questions/19454837/bash-histsize-vs-histfilesize )
shopt -s histappend
HISTFILESIZE= # Never truncate the file
# Use ignoreboth instead of ignoredups so that tmux-resurrect history save
# commands will not be saved. See
# https://github.com/tmux-plugins/tmux-resurrect
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history'
HOSTNAME="$(hostname)"
HOSTNAME_SHORT="${HOSTNAME%%.*}"
HISTFILE="${HOME}/.history/$(date -u +%Y/%m/%d.%H.%M.%S)_${HOSTNAME_SHORT}_$$"

# Use trap instead of PROMPT_COMMAND to append each command immediately instead
# of on session exit, minimizing the effect of sudden power losses
# See https://github.com/tmux-plugins/tmux-resurrect/issues/86
# PROMPT_COMMAND="history -a"
trap 'history -a $HISTFILE' DEBUG

bashrc_os=~/.config/bash/bashrc-os
[[ -f $bashrc_os ]] && source "$bashrc_os"

bashrc_local=~/.config/bash/bashrc-local
[[ -r $bashrc_local ]] && source "$bashrc_local"

set -o vi

if [ -f "$HOME/.fzf.bash" ]; then
  source "$HOME/.fzf.bash"
  # https://mike.place/2017/fzf-fd/
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow -E .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  # bind -x '"\C-p": vim $(fzf);'

  command -v fd >/dev/null && {
    _fzf_compgen_path() {
      fd --hidden --follow --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
      fd --type d --hidden --follow --exclude ".git" . "$1"
    }
  }

  command -v pytest >/dev/null && {
    _fzf_setup_completion path pytest
  }
fi

# yadm encrypt/decrypt will issue a
# "gpg: Inappropriate ioctl for device" error and bail out
# unless GPG_TTY is set.
# https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
# https://unix.stackexchange.com/questions/257061/gentoo-linux-gpg-encrypts-properly-a-file-passed-through-parameter-but-throws-i/257065#257065
GPG_TTY=$(tty)
export GPG_TTY

RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/config
export RIPGREP_CONFIG_PATH

eval "$(zoxide init bash)"
eval "$("$HOME/.local/bin/mise" activate bash)"
