return {
  'mfussenegger/nvim-lint',
  config = function()
    local lint = require('lint')

    -- I use prettier in formatter.nvim which sets one space before a comment
    -- By default, yamllint uses two, as per Python convention
    -- For my current setting, I can live with prettier's convention as a default.
    -- https://github.com/redhat-developer/vscode-yaml/issues/433
    -- https://github.com/prettier/prettier/pull/10926
    lint.linters.yamllint = {
      cmd = 'yamllint',
      stdin = true,
      args = {
        '-f',
        'parsable',
        '-d',
        '{extends: default, rules: {comments: {min-spaces-from-content: 1}}}',
        '-', -- read from stdin
      },
      stream = 'stdout',
      ignore_exitcode = true,
      parser = require('lint.parser').from_errorformat('%f:%l:%c: %t%*[^:]: %m', {
        source = 'yamllint',
        severity = {
          W = vim.diagnostic.severity.WARN,
          E = vim.diagnostic.severity.ERROR,
        },
      }),
    }

    -- Copied from https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/cpplint.lua and added args
    lint.linters.cpplint = {
      cmd = 'cpplint',
      stdin = false,
      args = { '--config', '.cpplintrc', '--filter', '-legal/copyright' },
      ignore_exitcode = true,
      stream = 'stderr',
      parser = require('lint.parser').from_pattern(pattern, groups, nil, {
        ['source'] = 'cpplint',
        ['severity'] = vim.diagnostic.severity.WARN,
      }),
    }

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
