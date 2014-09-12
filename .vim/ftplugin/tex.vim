:nmap <Leader>j :make<CR>
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
set wildignore+=*.aux,*.dvi,*.out,*.log,*.pdf
