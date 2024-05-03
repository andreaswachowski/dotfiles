-- https://docs.rubocop.org/rubocop/1.63/usage/lsp.html#neovim-nvim-lspconfig
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'ruby',
  callback = function()
    vim.lsp.start({
      name = 'rubocop',
      cmd = { 'bundle', 'exec', 'rubocop', '--lsp' },
    })
  end,
})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.rb',
  callback = function() vim.lsp.buf.format() end,
})
