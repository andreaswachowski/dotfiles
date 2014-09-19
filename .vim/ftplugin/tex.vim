:nmap <Leader>j :make<CR>
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
set wildignore+=*.aux,*.dvi,*.out,*.log,*.pdf

" I know how to use LaTeX dashes
let g:syntastic_quiet_messages = { "regex": 'Wrong length of dash may have been used' }
