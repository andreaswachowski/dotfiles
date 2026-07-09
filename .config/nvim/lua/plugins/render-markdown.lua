return {
  'MeanderingProgrammer/render-markdown.nvim',
  after = { 'nvim-treesitter' },
  requires = { 'nvim-mini/mini.nvim', opt = true },
  opts = {
    heading = {
      enabled = false,
      width = 'block',
    },
    pipe_table = {
      enabled = false,
    },
  },
}
