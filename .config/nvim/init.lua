--set paths during transition from ~/.vimrc
--[[vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
]]

vim.g.mapleader = ','

--neovim's thin bar becomes black and invisible, use block cursor instead
vim.o.guicursor = "i-ci-ve:block"

-- line numbers helps during pair programming
vim.o.number = true

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
  { 'tpope/vim-fugitive',
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
  { 'andreaswachowski/yadm-git.vim',
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

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth'
}, {})

--[[ Approach:
--   Read .vimrc and copy over only what I need
--   Note down line reached to mark progress.
--   Once done, remove "source ~/.vimrc" above.
--]]

-- analyzed up to line 60
vim.cmd([[source ~/.vimrc]])
