return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'antoinemadec/FixCursorHold.nvim',
    'olimorris/neotest-rspec',
    'nvim-neotest/neotest-plenary',
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields

    -- https://github.com/ChristianChiarulli/nvim/blob/c75f913d66cdde3f6dadfc8207bf0a526e8b8d08/lua/user/extras/neotest.lua#L19
    local wk = require('which-key')
    -- stylua: ignore
    wk.add({
      { "<leader>tt", "<cmd>lua require'neotest'.run.run()<cr>", desc = 'Test Nearest' },
      { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = 'Test File', },
      { "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = 'Debug Test', },
      { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle Summary" },
      { "<leader>tS", "<cmd>lua require('neotest').run.stop()<cr>", desc = 'Test Stop' },
      { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = 'Attach Test' },
    })
    require('neotest').setup({
      adapters = {
        require('neotest-rspec'),
        require('neotest-plenary'),
      },

      -- https://github.com/LazyVim/LazyVim/blob/c9ab8224f54fb6e93050fab1043b9d1efb917c23/lua/lazyvim/plugins/extras/test/core.lua#L111
      -- stylua: ignore
      -- keys = {
      --   { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest" },
      --   { "<leader>tT", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      --   { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      --   { "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      --   { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" }
      -- },
    })
  end,
}
