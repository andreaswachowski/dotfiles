-- commit.msg is added to the global .gitignore and serves as draft area for
-- commit messages
vim.cmd([[autocmd BufEnter commit.msg setlocal tw=72 et sw=4 ts=4]])

vim.api.nvim_create_augroup('_git', { clear = true })

-- Enable spell check, word wrap and convenient tabstops for git commits
vim.api.nvim_create_autocmd('FileType', {
  group = '_git',
  pattern = 'gitcommit',
  callback = function()
    vim.cmd('setlocal spell')
    vim.cmd('setlocal wrap')
    vim.cmd([[setlocal et sw=4 ts=4]])
  end,
})
