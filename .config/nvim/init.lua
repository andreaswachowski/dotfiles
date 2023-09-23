--set paths during transition from ~/.vimrc
vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
]])

vim.g.mapleader = ','

--neovim's thin bar becomes black and invisible, use block cursor instead
vim.o.guicursor = "i-ci-ve:block"

-- line numbers helps during pair programming
vim.o.number = true

-- neovim has "nnoremap Y y$" (see default-mappings), undo that
vim.cmd([[unmap Y]])

--[[ Store temporary files in a central spot to ease
     clean-up after machine crashes
     https://github.com/tpope/vim-obsession/issues/18]]
vim.cmd([[
let vimtmp = $HOME . '/tmp/vim/' . getpid()
silent! call mkdir(vimtmp, "p", 0700)
let &backupdir=vimtmp
let &directory=vimtmp
]])

--[[ Approach:
--   Read .vimrc and copy over only what I need
--   Note down line reached to mark progress.
--   Once done, remove "source ~/.vimrc" above.
--]]

-- analyzed up to line 51
vim.cmd([[source ~/.vimrc]])
