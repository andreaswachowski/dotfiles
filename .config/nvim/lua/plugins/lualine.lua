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

-- Cache git-root lookups per directory: the statusline redraws on nearly
-- every cursor move, and a directory's git root can't change mid-session.
local git_root_cache = {} -- dir -> root string or false (negative cache)

local function get_git_root(dir)
  if git_root_cache[dir] ~= nil then
    return git_root_cache[dir] or nil
  end
  local gitdir = vim.fs.find('.git', { upward = true, path = dir })[1]
  local root = gitdir and vim.fn.fnamemodify(gitdir, ':h') or nil
  git_root_cache[dir] = root or false
  return root
end

-- Show oil.nvim/file paths as <project>/<path-relative-to-repo-root> when
-- inside a git repo, or ~/<path> relative to $HOME otherwise.
local function display_path()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == '' then
    return '[No Name]'
  end
  local path = bufname:gsub('^oil://', '')
  local dir = vim.fn.fnamemodify(path, ':p:h')
  local root = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.root
    or get_git_root(dir)

  if root then
    local project = vim.fn.fnamemodify(root, ':t')
    local rel = path:sub(#root + 2)
    return rel ~= '' and (project .. '/' .. rel) or project
  end

  return vim.fn.fnamemodify(path, ':~')
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
        { display_path, fmt = trunc(100, 80, 50, false) },
        { 'branch', fmt = trunc_branch(120, 15, 100, false) },
      },
      lualine_x = {
        {
          'encoding',
          fmt = function(str)
            if str ~= 'utf-8' then return str end
          end,
        },
        { 'fileformat', fmt = trunc(120, 1, 120, true) },
        { 'filetype', fmt = trunc(90, 3, 120, true) },
      },
      lualine_y = { { 'progress', fmt = trunc(90, 3, 90, true) } },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { display_path } },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
