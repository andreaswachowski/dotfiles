return {
  "mfussenegger/nvim-lint",
  config = function()
    local rubocop = require('lint').linters.rubocop
    rubocop.cmd = 'bundle'
    rubocop.args = { 'exec', 'rubocop', '--format', 'json', '--force-exclusion' }
    -- rubocop.stdin = true
    require('lint').linters_by_ft = {
      ruby = {
        "rubocop"
      }
    }
    vim.api.nvim_create_autocmd(
      { "BufWritePost" },
      { callback = function() require("lint").try_lint() end, }
    )
  end
}
