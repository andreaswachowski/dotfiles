-- https://github.com/nvim-telescope/telescope.nvim/issues/2088#issuecomment-1189352587
vim.api.nvim_create_autocmd(
  'FileType',
  { pattern = 'TelescopePrompt', callback = function() vim.opt_local.paste = false end }
)
