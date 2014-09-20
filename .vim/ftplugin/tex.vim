autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
set wildignore+=*.aux,*.dvi,*.out,*.log,*.pdf

" http://stackoverflow.com/questions/1089028/is-it-possible-to-call-make-in-vim-in-linux-without-showing-the-shell
nnoremap <leader>m :silent make\|redraw!\|cw<CR>

" I know how to use LaTeX dashes
let g:syntastic_quiet_messages = { "regex": 'Wrong length of dash may have been used' }
