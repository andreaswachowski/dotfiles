if exists('g:loaded_indentconsistencycop')
  " Avoid indentation checks for 3rd-party files
  au BufReadPre ~/dotfiles/.vim/bundle/* let b:indentconsistencycop_SkipChecks = 1
  au BufReadPre ~/.vim/bundle/* let b:indentconsistencycop_SkipChecks = 1
  au BufReadPre */node_modules/* let b:indentconsistencycop_SkipChecks = 1
  au BufReadPre */bower_components/* let b:indentconsistencycop_SkipChecks = 1
endif
