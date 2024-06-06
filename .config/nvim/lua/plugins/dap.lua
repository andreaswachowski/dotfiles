return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',
    'suketa/nvim-dap-ruby',
  },
  optional = true,
  -- stylua: ignore
  keys = {
    { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'Debug Nearest', },
  },
  -- config is in after/plugin/dap.lua !
}
