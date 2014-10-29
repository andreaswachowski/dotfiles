set ts=2
set sw=2
set expandtab

" http://stackoverflow.com/questions/1089028/is-it-possible-to-call-make-in-vim-in-linux-without-showing-the-shell
nnoremap <leader>m :silent make\|redraw!\|cc<CR>
