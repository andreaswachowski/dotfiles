return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  opts = function(_, opts)
    if type(opts.ensure_installed) == 'table' then
      vim.list_extend(opts.ensure_installed, { 'markdown' })
      vim.treesitter.language.register('markdown', 'mdx')
    end
  end,
  -- config is in after/plugin/treesitter !
}
