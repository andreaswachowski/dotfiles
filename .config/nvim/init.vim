set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" neovim's thin bar becomes black and invisible, use block cursor instead
set guicursor=i-ci-ve:block

" see default-mappings
unmap Y

source ~/.vimrc
