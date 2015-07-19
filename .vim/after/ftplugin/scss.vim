set ts=2
set sw=2
set expandtab

autocmd BufWritePre *.scss :%s/\s\+$//e
