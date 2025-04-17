vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*/typescript/k8s/chart/*.yaml',
  callback = function() vim.bo.filetype = 'helm' end,
})
