return {
  'andreaswachowski/taskpaper.vim',
  lazy = false,
  keys = {
    ---@diagnostic disable-next-line: missing-fields
    {
      '<leader>tc',
      "<cmd>call taskpaper#toggle_tag('created', taskpaper#date())<cr>",
      desc = 'Toggle created tag with current date',
    },
  },
  config = function()
    vim.cmd([[autocmd FileType taskpaper setlocal shiftwidth=2 tabstop=2]])
  end,
}
