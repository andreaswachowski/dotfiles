--set paths during transition from ~/.vimrc
--[[vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
]]

local modules = {
  'aw.globals',
  'config.options',
  'config.keymaps',
  'autocommands',
  'config.lazy',
  'lsp',
}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then error('Error loading ' .. module .. '\n\n' .. err) end
end

-- [[ Import other stuff ]]
-- Someday I might migrate from my custom solution to
-- https://github.com/kazhala/close-buffers.nvim
vim.cmd([[source ~/.vim/delete_inactive_buffers.vim]])
-- vim.cmd([[source ~/.vimrc]])
vim.cmd([[source ~/.config/nvim/move_file.vim]])
-- vim: ts=2 sts=2 sw=2 et
