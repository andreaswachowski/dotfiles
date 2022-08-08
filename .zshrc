[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Setup autocompletion
# For "insecure directories" warning, use "compaudit | xargs chmod g-w" once
autoload -Uz compinit && compinit

# Show branch name right-aligned
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT='${vcs_info_msg_0_}'
# PROMPT='${vcs_info_msg_0_}%# '
zstyle ':vcs_info:git:*' formats '%b'
