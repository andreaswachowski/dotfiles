--set paths during transition from ~/.vimrc
--[[vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
]]

vim.cmd([[let g:matchup_matchparen_enabled = 0]])
vim.cmd([[let g:markdown_syntax_conceal = 0]])

-- vim.lsp.set_log_level('debug')

local modules = {
  'aw.globals',
  'config.options',
  'config.keymaps',
  'config.env',
  'autocommands',
  'config.lazy',
  'lsp',
}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then error('Error loading ' .. module .. '\n\n' .. err) end
end

-- To close a buffer without closing the tab (and its cd settings)
vim.cmd([[nnoremap <silent> <leader>bd :enew<CR>]])

-- [[ Import other stuff ]]
-- Someday I might migrate from my custom solution to
-- https://github.com/kazhala/close-buffers.nvim
vim.cmd([[source ~/.vim/delete_inactive_buffers.vim]])
-- vim.cmd([[source ~/.vimrc]])
vim.cmd([[source ~/.config/nvim/move_file.vim]])
-- vim: ts=2 sts=2 sw=2 et
