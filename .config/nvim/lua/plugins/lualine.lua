return {
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
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
