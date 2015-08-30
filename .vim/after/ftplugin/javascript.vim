" Automatically remove trailing spaces before writing the file
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
autocmd BufWritePre *.js :%s/\s\+$//e

" According to https://github.com/Valloric/YouCompleteMe/issues/570 :
autocmd FileType javascript setlocal omnifunc=tern#Complete
