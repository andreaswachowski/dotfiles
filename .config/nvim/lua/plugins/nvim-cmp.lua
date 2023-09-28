return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',

  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        "saadparwaiz1/cmp_luasnip",
        'rafamadriz/friendly-snippets',
      }
    },

    -- Add LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
  },
}
