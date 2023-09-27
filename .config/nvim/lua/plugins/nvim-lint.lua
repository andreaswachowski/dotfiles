return {
  "mfussenegger/nvim-lint",
  config = function()
    local rubocop = require('lint').linters.rubocop
    rubocop.cmd = 'bundle'
    rubocop.args = { 'exec', 'rubocop', '--format', 'json', '--force-exclusion', '--stdin', vim.api.nvim_buf_get_name(0) }
    rubocop.stdin = true
    require('lint').linters_by_ft = {
      ruby = {
        "rubocop"
      }
    }
    vim.api.nvim_create_autocmd(
      { "BufReadPost", "BufWritePost", "InsertLeave", "TextChanged" },
      { callback = function() require("lint").try_lint() end, }
    )
  end
}
