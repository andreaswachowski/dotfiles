return {
  'mhartington/formatter.nvim',
  -- This commit implements try_node_modules
  -- https://github.com/mhartington/formatter.nvim/pull/291
  commit = 'e2f43a15ae71d7bd66f1a27577a346831b28c0b1',
  config = function()
    local formatter = require('formatter')
    formatter.setup({
      filetype = {
        cpp = {
          function()
            return {
              exe = 'clang-format',
              args = {
                '-assume-filename=',
                vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
                -- https://clang.llvm.org/docs/ClangFormatStyleOptions.html
                -- https://github.com/mhartington/formatter.nvim/issues/52
                '--style="{BasedOnStyle: Chromium}"',
              },
              stdin = true,
            }
          end,
        },
        javascript = require('formatter.filetypes.javascript').prettier,
        javascriptreact = require('formatter.filetypes.javascript').prettier,
        json = require('formatter.filetypes.json').prettier,
        lua = require('formatter.filetypes.lua').stylua,
        sh = {
          require('formatter.filetypes.sh').shfmt,

          function()
            return {
              -- According to shfmt's man page, similar to
              -- https://google.github.io/styleguide/shellguide.html
              args = {
                '--indent 2',
                '--case-indent',
                '--binary-next-line',
              },
            }
          end,
        },
        typescript = require('formatter.filetypes.typescript').prettier,
        typescriptreact = require('formatter.filetypes.typescript').prettier,
        vue = require('formatter.filetypes.vue').prettier,
        yaml = require('formatter.filetypes.yaml').prettier,
        ['*'] = {
          require('formatter.filetypes.any').remove_trailing_whitespace,
        },
      },
    })
    vim.keymap.set('n', '<leader>f', '<cmd>Format<cr>', { noremap = true, silent = true })
    vim.cmd([[augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost * FormatWrite
    augroup END]])
  end,
}
