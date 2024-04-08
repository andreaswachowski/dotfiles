return {
  -- for a lua implementation, see robstumborg/yadm.nvim
  'seanbreckenridge/yadm-git.vim',
  dependencies = { 'tpope/vim-fugitive' },
  config = function()
    vim.g.yadm_git_gitgutter_enabled = 0 -- I use gitsigns instead
  end,
}
