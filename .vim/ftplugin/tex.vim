autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
setlocal wildignore+=*.aux,*.dvi,*.out,*.log,*.pdf

" http://stackoverflow.com/questions/1089028/is-it-possible-to-call-make-in-vim-in-linux-without-showing-the-shell
nnoremap <leader>m :silent make\|redraw!\|cw<CR>
