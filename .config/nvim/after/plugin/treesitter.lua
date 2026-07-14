-- [[ Treesitter — nvim-treesitter `main` branch ]]
local ts = require('nvim-treesitter')

-- Keep these parsers installed (replaces master's `ensure_installed`; runs async,
-- no-op when already present). `:TSUpdate` (plugin `build`) keeps them current.
ts.install({
  'bash',
  'c',
  'cpp',
  'css',
  'dockerfile',
  'gitignore',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'ruby',
  'rust',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
})

vim.treesitter.language.register('markdown', 'mdx')

-- Filetypes where TS indentation misbehaved (was `indent = { disable = {...} }`)
local no_ts_indent = { ruby = true, typescript = true, markdown = true }

-- Per-buffer: start highlighting + indentation (replaces the `highlight`/`indent` modules).
local function attach(buf)
  local ft = vim.bo[buf].filetype
  if ft == '' then return end
  local lang = vim.treesitter.language.get_lang(ft) or ft
  local ok, added = pcall(vim.treesitter.language.add, lang)
  if not ok or not added then return end -- no parser -> leave legacy syntax alone
  vim.treesitter.start(buf, lang)
  -- Reproduce `additional_vim_regex_highlighting = { 'ruby' }`: ruby keeps legacy
  -- syntax on top of TS; every other filetype is TS-only.
  if ft ~= 'ruby' then vim.bo[buf].syntax = '' end
  if not no_ts_indent[ft] then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('aw_treesitter', { clear = true }),
  callback = function(args) attach(args.buf) end,
})

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) then attach(buf) end
end

require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

--stylua: ignore start

local sel = require('nvim-treesitter-textobjects.select')

vim.keymap.set({ 'x', 'o' }, 'aa', function() sel.select_textobject('@parameter.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ia', function() sel.select_textobject('@parameter.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'af', function() sel.select_textobject('@function.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'if', function() sel.select_textobject('@function.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ac', function() sel.select_textobject('@class.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ic', function() sel.select_textobject('@class.inner', 'textobjects') end)

local move = require('nvim-treesitter-textobjects.move')

vim.keymap.set({ 'n', 'x', 'o' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '][', function() move.goto_next_end('@class.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end)

local swap = require('nvim-treesitter-textobjects.swap')

vim.keymap.set('n', '<leader>a', function() swap.swap_next('@parameter.inner') end)
vim.keymap.set('n', '<leader>A', function() swap.swap_previous('@parameter.inner') end)

--stylua: ignore end
