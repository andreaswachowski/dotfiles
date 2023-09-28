--set paths during transition from ~/.vimrc
--[[vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
]]


-- Setup globals that I expect to be always available.
--  See `./lua/aw/globals.lua` for more information.
require "aw.globals"

vim.g.mapleader = ','

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

require("config.lazy")

-- [[ Setting options ]]

require("config.options")

-- [[ Basic Keymaps ]]

-- Vim Tip 173: Quick movement between split windows
-- https://vim.fandom.com/wiki/Switch_between_Vim_window_splits_easily
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<c-l>', '<c-w>l', opts)
vim.keymap.set('n', '<c-h>', '<c-w>h', opts)
vim.keymap.set('n', '<c-k>', '<c-w>k', opts)
vim.keymap.set('n', '<c-j>', '<c-w>j', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Autocommands ]]

require('autocommands')

-- [[ Import other stuff ]]
-- Show directories in tabline.
-- The idea is to handle one project per tab, using the buffer list for all
-- project-related files. Thus, each tab is set to a different tab-local
-- directory.
vim.cmd([[source ~/.vim/tabline.vim]])
-- Someday I might migrate from my custom solution to
-- https://github.com/kazhala/close-buffers.nvim
vim.cmd([[source ~/.vim/delete_inactive_buffers.vim]])
-- vim.cmd([[source ~/.vimrc]])
-- vim: ts=2 sts=2 sw=2 et
