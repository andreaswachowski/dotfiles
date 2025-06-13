vim.api.nvim_create_augroup('RubyStacktrace', { clear = true })
vim.api.nvim_create_autocmd('BufRead', {
  group = 'RubyStacktrace',
  -- pattern = 'quickfix',
  callback = function()
    if vim.fn.getline('1'):match(os.getenv('HOME') .. '.*%.rb:%d+:.*') then
      vim.opt_local.syntax = 'ruby_stacktrace'
      vim.cmd('setlocal nowrap')
    end
  end,
})
