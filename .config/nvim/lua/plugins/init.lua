return {
  -- [[ Editing-related plugins ]]

  { 'tpope/vim-obsession' },

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function() require('nvim-surround').setup() end,
  },

  -- Detect tabstop and shiftwidth automatically
  -- { 'tpope/vim-sleuth' },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {},
  },

  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = function() vim.fn['mkdp#util#install']() end,
  },

  { 'pearofducks/ansible-vim' },
  { 'tpope/vim-rails' },
  { 'skywind3000/asyncrun.vim' },
  'openjck/vim-yadm-files',
  'Glench/Vim-Jinja2-Syntax',
}
