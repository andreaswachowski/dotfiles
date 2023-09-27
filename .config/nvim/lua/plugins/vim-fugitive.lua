return {
  'tpope/vim-fugitive',
  keys = {
    ---@diagnostic disable: missing-fields
    { "<Bslash>cs", "<cmd>Git<cr>", desc = "Git status" },
    { "<Bslash>cc", "<cmd>Git commit<cr>", desc = "Git commit" },
    { "<Bslash>cv", "<cmd>Gdiff<cr>", desc = "Git diff" },
    { "<Bslash>cl", "<cmd>Gclog<cr>", desc = "Git log" },
    { "<Bslash>cb", "<cmd>Git blame<cr>", desc = "Git blame" },
    ---@diagnostic enable: missing-fields
  },
  config = function()
    -- Include (mailmap'ed) author and a date indication in the fugitive
    -- Glog quickfix entries
    vim.g.fugitive_summary_format = "%aN %ai %s"
  end
}
