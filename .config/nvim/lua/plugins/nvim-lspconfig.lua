return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    {
      'williamboman/mason-lspconfig.nvim',
      ensure_installed = {
        'bashls',
        'clangd',
        'lua_ls',
        'jsonls',
        'pyright',
        'ruby_ls',
        'tsserver',
      },
    },

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
  },
}
