return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      auto_install = true,
      ensure_installed = {
        -- defaults
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',

        -- in addition:
        'bash',
        'css',
        'cpp',
        'dockerfile',
        'gitignore',
        'html',
        'javascript',
        'json',
        'markdown',
        'markdown_inline',
        'python',
        'ruby',
        'tsx',
        'typescript',
        'yaml',
      },
    })
  end,
}
