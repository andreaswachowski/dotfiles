return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'antoinemadec/FixCursorHold.nvim',
    'olimorris/neotest-rspec',
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('neotest').setup({
      adapters = {
        require('neotest-rspec'),
      },
    })
  end,
}
