export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
{
  export PNPM_HOME="$HOME/Library/pnpm"
  case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
}

eval "$(rbenv init -)"
command -v rbenv >/dev/null && {
  # Required by rbenv-default-gems,
  # see https://github.com/rbenv/rbenv-default-gems/issues/1
  export RBENV_ROOT=$HOME/.rbenv
}
command -v rspec >/dev/null && {
  _fzf_complete_rspec() {
    _fzf_complete -- "$@" < <(fd _spec.rb spec)
  }

  complete -F _fzf_complete_rspec -o default -o bashdefault rspec
  complete -F _fzf_complete_rspec -o default -o bashdefault be rspec
  complete -F _fzf_complete_rspec -o default -o bashdefault bundle exec rspec
}

# by default, ulimit -n is only 256. With that low setting, largeish vim
# sessions will fail in git-conflict.nvim with
#
# Error detected while processing VimEnter Autocommands for "*":
# Error executing lua callback: Vim:E903: Process failed to start: too many open files: "/usr/local/bin/git"
# stack traceback:
#
#  [C]: in function 'jobstart'
#  ...e/nvim/lazy/git-conflict.nvim/lua/git-conflict/utils.lua:25: in function 'job'
#  ...l/share/nvim/lazy/git-conflict.nvim/lua/git-conflict.lua:173: in function 'get_git_root'
#  ...l/share/nvim/lazy/git-conflict.nvim/lua/git-conflict.lua:410: in function 'fetch_conflicts'
#  ...l/share/nvim/lazy/git-conflict.nvim/lua/git-conflict.lua:622: in function <...l/share/nvim/lazy/git-conflict.nvim/lua/git-conflict.lua:618>
ulimit -n 65536
