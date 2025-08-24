-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup({
  endwise = {
    enable = true,
  },
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
    'rust',
    'tsx',
    'typescript',
    'yaml',
  },
  incremental_selection = {
    enable = true,
    disable = { 'org' }, -- conflicts with checklist toggle
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  indent = { enable = true, disable = { 'ruby', 'markdown' } },
  highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' } },
  matchup = {
    -- https://github.com/andymass/vim-matchup/issues/198
    enable = true,
    disable = { 'ruby' },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      disable = { 'org' },
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
})
