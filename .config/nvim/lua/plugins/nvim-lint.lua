return {
  'mfussenegger/nvim-lint',
  config = function()
    require('lint').linters_by_ft = {
      cpp = { 'cpplint' },
      css = { 'stylelint' },
      dockerfile = { 'hadolint' },
      gitcommit = { 'vale' },
      javascript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      json = { 'jsonlint' },
      markdown = { 'vale' },
      sh = { 'shellcheck' },
      text = { 'vale' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      yaml = { 'yamllint' },
      ['yaml.ansible'] = { 'ansible_lint' },
    }
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
      callback = function()
        require('lint').try_lint()
        -- The linting works even with monorepos, but just in case
        -- it wouldn't, there's an idea here from
        -- https://github.com/mfussenegger/nvim-lint/issues/482
        -- local get_clients = vim.lsp.get_clients
        -- local client = get_clients({ bufnr = 0 })[1] or {}
        -- require('lint').try_lint(nil, { cwd = client.root_dir })
      end,
    })
  end,
}
