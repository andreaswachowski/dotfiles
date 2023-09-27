return {
  "mhartington/formatter.nvim",
  config = function()
    local formatter = require("formatter")
    formatter.setup({
      filetype = {
        lua = require("formatter.filetypes.lua").stylua,
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace
        }
      }
    })
    vim.keymap.set('n', '<leader>f', '<cmd>Format<cr>', { noremap = true, silent = true })
    vim.cmd([[augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost * FormatWrite
    augroup END]])
  end
}
