--set paths during transition from ~/.vimrc
--[[vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
]]


-- Setup globals that I expect to be always available.
--  See `./lua/aw/globals.lua` for more information.
require "aw.globals"

vim.g.mapleader = ','

require("config.lazy")

-- [[ Setting options ]]

require("config.options")

-- [[ Basic Keymaps ]]

require("config.keymaps")

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
