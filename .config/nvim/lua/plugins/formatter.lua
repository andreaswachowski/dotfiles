return {
  'mhartington/formatter.nvim',
  -- This commit implements try_node_modules
  -- https://github.com/mhartington/formatter.nvim/pull/291
  commit = 'e2f43a15ae71d7bd66f1a27577a346831b28c0b1',
  config = function()
    local formatter = require('formatter')
    local util = require('formatter.util')
    local fname = vim.api.nvim_buf_get_name(0)
    local ruby_formatter = require('formatter.filetypes.ruby').rubocop
    if require('lspconfig').util.root_pattern('Gemfile')(fname) ~= nil then
      ruby_formatter = function()
        return {
          exe = 'bundle',
          args = {
            'exec',
            'rubocop',
            '--fix-layout',
            '--stdin',
            util.escape_path(util.get_current_buffer_file_path()),
            '--format',
            'files',
            '--stderr',
          },
          stdin = true,
        }
      end
    end
    formatter.setup({
      filetype = {
        cpp = require('formatter.filetypes.cpp').clangformat,
        sh = require('formatter.filetypes.sh').shfmt,
        lua = require('formatter.filetypes.lua').stylua,
        ruby = ruby_formatter,
        ['*'] = {
          require('formatter.filetypes.any').remove_trailing_whitespace,
        },
      },
    })
    vim.keymap.set(
      'n',
      '<leader>f',
      '<cmd>Format<cr>',
      { noremap = true, silent = true }
    )
    vim.cmd([[augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost * FormatWrite
    augroup END]])
  end,
}
