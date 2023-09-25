--set paths during transition from ~/.vimrc
--[[vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
]]

vim.g.mapleader = ','

-- neovim has "nnoremap Y y$" (see default-mappings), undo that
vim.cmd([[unmap Y]])

--[[ Store temporary files in a central spot to ease
     clean-up after machine crashes
     https://github.com/tpope/vim-obsession/issues/18]]
vim.cmd([[
let vimtmp = $HOME . '/tmp/vim/' . getpid()
silent! call mkdir(vimtmp, "p", 0700)
let &backupdir=vimtmp
let &directory=vimtmp
]])

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
  { 'tpope/vim-obsession' },

  {
    'tpope/vim-fugitive',
    keys = {
      { "<Bslash>cs", "<cmd>Git<cr>", desc = "Git status" },
      { "<Bslash>cc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<Bslash>cv", "<cmd>Gdiff<cr>", desc = "Git diff" },
      { "<Bslash>cl", "<cmd>Gclog<cr>", desc = "Git log" },
      { "<Bslash>cb", "<cmd>Git blame<cr>", desc = "Git blame" },
    },
    config = function()
      -- Include (mailmap'ed) author and a date indication in the fugitive
      -- Glog quickfix entries
      vim.g.fugitive_summary_format = "%aN %ai %s"
    end
  },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- for a lua implementation, see robstumborg/yadm.nvim
  {
    'andreaswachowski/yadm-git.vim',
    dependencies = { 'tpope/vim-fugitive' }
  },

  -- Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "dark", -- background as dark as terminal
      invert_tabline = true,
      overrides = {
        -- Lighten some grays. Start with dark4 (== #7c6f64 == rgb(124 111 100))
        -- and add 50 each to R, G, and B, yielding rgb(174, 161, 150) = #95887d
        SpecialKey = { fg = "#95887d" },
        Whitespace = { fg = "#95887d" }, -- shown with "set list" (":help listchars"
        LineNr = { fg = "#95887d" },
        Comment = { fg = "#95887d" },
        Folded = { fg = "#95887d" },
      }
    },
    config = function(_, opts)
      require('gruvbox').setup(opts)
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
        lualine_a = {'branch', 'diff', 'diagnostics'},
        lualine_b = {{'filename', path = 1}},
        lualine_c = {},
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

}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

vim.o.breakindent = true

-- use vertical diff
vim.o.diffopt = "internal,algorithm:patience,filler,closeoff,vertical"

--neovim's thin bar becomes black and invisible, use block cursor instead
vim.o.guicursor = "i-ci-ve:block"

vim.o.hlsearch = false   -- Set highlight on search
vim.o.mouse = 'a' -- enable mouse mode
vim.o.number = true -- line numbers helps during pair programming
vim.o.termguicolors = true
vim.o.textwidth = 80 -- keep to "sane" width unless explicitly overridden
vim.o.tildeop = true
vim.o.timeoutlen = 300 -- wait for a mapped sequence to complete, default 1000
vim.o.undofile = true
vim.o.updatetime = 500 -- delay after swap file is written, default 4000
vim.o.visualbell = true
vim.cmd([[set wildignore+=*.jpg,*.png,*.o]])
-- vim.o.wildignore:append{'*.jpg', '*.png', '*.o'} doesn't work when
-- wildignore is empty
vim.o.winminheight = 0 -- minimize a window to just its status bar

-- [[ Basic Keymaps ]]

-- Vim Tip 173: Quick movement between split windows
-- https://vim.fandom.com/wiki/Switch_between_Vim_window_splits_easily
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-j>', '<c-w>j')

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })

-- [[ Import other stuff ]]
-- Show directories in tabline.
-- The idea is to handle one project per tab, using the buffer list for all
-- project-related files. Thus, each tab is set to a different tab-local
-- directory.
vim.cmd([[source ~/.vim/tabline.vim]])
-- Someday I might migrate from my custom solution to
-- https://github.com/kazhala/close-buffers.nvim
vim.cmd([[source ~/.vim/delete_inactive_buffers.vim]])
-- vim.cmd([[source ~/.vimrc]])
