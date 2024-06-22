local ls = require('luasnip')
ls.config.set_config({})

-- https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
-- uses <C-K> instead of <C-J>, but <C-K> is needed for digraphs
vim.keymap.set({ 'i' }, '<C-J>', function() ls.expand() end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-L>', function() ls.jump(1) end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-H>', function() ls.jump(-1) end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-E>', function()
  if ls.choice_active() then ls.change_choice(1) end
end, { silent = true })

vim.keymap.set('n', '<leader><leader>s', '<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>')

require('luasnip.loaders.from_vscode').lazy_load()
