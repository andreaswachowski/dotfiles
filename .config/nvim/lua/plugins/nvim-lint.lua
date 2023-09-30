return {
  'mfussenegger/nvim-lint',
  config = function()
    local fname = vim.api.nvim_buf_get_name(0)
    if require('lspconfig').util.root_pattern('Gemfile')(fname) == nil then
      local rubocop = require('lint').linters.rubocop
      rubocop.args = {
        '--format',
        'json',
        '--force-exclusion',
        '--stdin',
        vim.api.nvim_buf_get_name(0),
      }
      rubocop.stdin = true
      require('lint').linters_by_ft = {
        ansible = { 'ansible-lint' },
        dockerfile = { 'hadolint' },
        markdown = { 'vale' },
        sh = { 'ShellCheck' },
        json = { 'jsonlint' },
        ruby = { 'rubocop' },
      }
      vim.api.nvim_create_autocmd(
        { 'BufEnter', 'BufWritePost', 'InsertLeave', 'TextChanged' },
        {
          callback = function()
            require('lint').try_lint()
          end,
        }
      )
    end
  end,
}
