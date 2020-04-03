if exists( "g:loaded_youcompleteme" )
  " In addition to the default values, disable c and cpp
  let g:ycm_filetype_blacklist = {
        \ 'tagbar' : 1,
        \ 'qf' : 1,
        \ 'notes' : 1,
        \ 'markdown' : 1,
        \ 'unite' : 1,
        \ 'text' : 1,
        \ 'vimwiki' : 1,
        \ 'pandoc' : 1,
        \ 'infolog' : 1,
        \ 'mail' : 1,
        \ 'cpp' : 1,
        \ 'c' : 1
        \}

  " In order to make sure I can use syntastic instead, I need to disable this
  " option, too. Otherwise, YCM removes all Syntastic checkers for c and cpp,
  " amongst others.
  let g:ycm_show_diagnostics_ui = 0

  nmap <silent> kt :YcmCompleter GoTo<CR> " kt, because gt is standard for "Go to the next tab page"
  nmap <silent> gd :YcmCompleter GoToDefinition<CR>
  nmap <silent> gD :YcmCompleter GetDoc<CR>
  nmap <silent> gi :YcmCompleter GoToImplementation<CR>
  nmap <silent> gr :YcmCompleter GoToReferences<CR>
endif
