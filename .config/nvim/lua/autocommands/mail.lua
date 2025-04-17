-- For neomutt
vim.cmd([[autocmd BufRead,BufNewFile neomutt-* set filetype=mail]])
-- When opening ~/Mail files directly in vim
vim.cmd(
  [[autocmd BufRead,BufNewFile * if getline(1) =~ '^\(From \|Return-path: \)' | set filetype=mail | endif]]
)
