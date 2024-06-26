return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',

  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      dependencies = {
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets',
      },
    },

    'onsails/lspkind.nvim', -- Show sources in completion list
    'hrsh7th/cmp-buffer', -- Basic completion from buffer words
    'hrsh7th/cmp-path', -- Filesystem path completion
    'hrsh7th/cmp-nvim-lua', -- Add Lua completion for Nvim
    'hrsh7th/cmp-nvim-lsp', -- Add LSP completion capabilities
  },
  -- config is in after/plugin/nvim-cmp.lua !
}
