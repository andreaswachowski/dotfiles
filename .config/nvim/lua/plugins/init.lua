return {
  -- [[ Editing-related plugins ]]

  { 'tpope/vim-obsession' },

  {
    'kylechui/nvim-surround',
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- [[ Git-related plugins ]]
  {
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
  },

  -- for a lua implementation, see robstumborg/yadm.nvim
  {
    'andreaswachowski/yadm-git.vim',
    dependencies = { 'tpope/vim-fugitive' }
  },

  -- [[ LSP ]]
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  -- Useful status updates for LSP
  -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    event = "LspAttach",
    opts = {}
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({'n', 'v'}, ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
        vim.keymap.set({'n', 'v'}, '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
      end,
    },
  },

  -- Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Lighten some grays. Start with dark4 (== #7c6f64 == rgb(124 111 100))
      -- and add 50 each to R, G, and B, yielding rgb(174, 161, 150) = #95887d
      local dark5 = "#95887d"
      local iterm2_bg = "#0e0e0e"
      local colors = require("gruvbox.palette")
      require('gruvbox').setup({
        contrast = "dark", -- background as dark as terminal
        invert_tabline = true,
        overrides = {
          SpecialKey = { fg = dark5 },
          Whitespace = { fg = dark5 }, -- shown with "set list" (":help listchars"
          LineNr = { fg = dark5 },
          Comment = { fg = dark5 },
          Folded = { fg = dark5 },
          SignColumn = { bg = "#0e0e0e" }, -- same as iTerm2 background"#0e0e0e"
          GruvboxRedSign = { fg = colors.red, bg = iterm2_bg, reverse = false },
          GruvboxGreenSign = { fg = colors.green, bg = iterm2_bg, reverse = false },
          GruvboxYellowSign = { fg = colors.yellow, bg = iterm2_bg, reverse = false },
          GruvboxBlueSign = { fg = colors.blue, bg = iterm2_bg, reverse = false },
          GruvboxPurpleSign = { fg = colors.purple, bg = iterm2_bg, reverse = false },
          GruvboxAquaSign = { fg = colors.aqua, bg = iterm2_bg, reverse = false },
          GruvboxOrangeSign = { fg = colors.orange, bg = iterm2_bg, reverse = false },
        },
      })
      vim.o.background = "dark" -- or "light" for dark mode
      vim.cmd.colorscheme 'gruvbox'
    end
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        theme = 'gruvbox',
        component_separators = '|',
        -- The section separator of the "progress" section disappears in insert
        -- mode (why I don't know), shifting section x to the right, which is
        -- irritating.
        -- Disable section_separators to avoid the shifting (also saving space).
        -- (Alternatively, one could include 'progress' in the preceding section)
        section_separators = '',
      },
      sections = {
        lualine_a = {},
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {{'filename', path = 1}},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', path = 1}},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    'iamcco/markdown-preview.nvim',
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  { 'tpope/vim-rails' },

  {
    'andreaswachowski/taskpaper.vim',
    lazy = false,
    keys = {
      ---@diagnostic disable-next-line: missing-fields
      {
        "<leader>tc", "<cmd>call taskpaper#toggle_tag('created', taskpaper#date())<cr>",
        desc = "Toggle created tag with current date"
      },
    },
    config = function()
      vim.cmd([[autocmd FileType taskpaper setlocal shiftwidth=2 tabstop=2]])
    end
  }
}
