require('autocommands.git')
require('autocommands.ruby')
require('autocommands.telescope')
require('autocommands.ruby_stacktrace')
vim.cmd([[autocmd FileType json,html,xml,yaml set tabstop=2 shiftwidth=2 expandtab]])
-- For nemoutt
vim.cmd([[autocmd BufRead,BufNewFile neomutt-* set filetype=mail]])
-- When opening ~/Mail files directly in vim
vim.cmd([[autocmd BufRead,BufNewFile * if getline(1) =~ '^\(From \|Return-path: \)' | set filetype=mail | endif]])
