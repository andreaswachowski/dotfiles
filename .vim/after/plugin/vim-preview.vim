if exists("g:loaded_preview")
  " vim-preview uses ruby, and various gems, in particular the redcarpet gem.
  " But 1) that's not part in all my rvm-rubies, and 2) even it would be, then
  " vim would crash upon invocation. vim with Ruby only works on Mac OS X with the
  " system-provided Ruby, and redcarpet compiles native extensions which would conflict
  " otherwise.
  " Hence to use preview with markdown, install redcarpet globally, then switch rubies
  " whenever entering a markdown file.
  if exists('g:loaded_rvm')
    au BufEnter *.md Rvm use system
    au BufLeave *.md Rvm
  endif

  " NOTE: In a rails project, tpope's vim-rails setting conflicts with vim-preview's
  " default mapping to :Preview, due to another definition of Preview
  " (see autoload/rails.vim:1000, 2c5c72aaf9711e)
  " I only use vim-preview for Markdown anyway, so I make the mapping unambiguous:
  :nmap <Leader>P :PreviewMarkdown<CR>
endif
