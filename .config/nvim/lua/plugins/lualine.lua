local gitsigns_available, _ = pcall(require, 'gitsigns')

-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#truncating-components-in-smaller-window
--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and '' or '…')
    end
    return str
  end
end

local function trunc_branch(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      if str:match('/') then
        return string.sub(str:match('/.*'), 2, trunc_len) .. (no_ellipsis and '' or '…')
      else
        return str:sub(1, trunc_len) .. (no_ellipsis and '' or '…')
      end
    end
    return str
  end
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

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
      lualine_b = {
        -- diff_source() and { 'diff', source = diff_source } or 'diff',
        gitsigns_available and { 'diff', source = diff_source } or 'diff',
        'diagnostics',
      },
      lualine_c = {
        { 'filename', path = 1, fmt = trunc(91, 40, 50, false) },
        { 'branch', fmt = trunc_branch(120, 15, 80, false) },
      },
      lualine_x = {
        {
          'encoding',
          fmt = function(str)
            if str ~= 'utf-8' then return str end
          end,
        },
        { 'fileformat', fmt = trunc(120, 1, 120, true) },
        { 'filetype', fmt = trunc(90, 3, 70, true) },
      },
      lualine_y = { { 'progress', fmt = trunc(90, 3, 90, true) } },
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
