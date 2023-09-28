-- Vim Tip 173: Quick movement between split windows
-- https://vim.fandom.com/wiki/Switch_between_Vim_window_splits_easily
local opts = { noremap = true, silent = true }

-- neovim has "nnoremap Y y$" (see default-mappings), undo that
vim.keymap.del('n', 'Y')

vim.keymap.set('n', '<c-l>', '<c-w>l', opts)
vim.keymap.set('n', '<c-h>', '<c-w>h', opts)
vim.keymap.set('n', '<c-k>', '<c-w>k', opts)
vim.keymap.set('n', '<c-j>', '<c-w>j', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
