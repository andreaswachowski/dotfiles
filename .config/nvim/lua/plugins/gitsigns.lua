return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'purarue/gitsigns-yadm.nvim',
      opts = {
        shell_timeout_ms = 2000,
      },
    },
  },
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    _on_attach_pre = function(_, callback)
      local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

      if ft == 'org' then return nil end

      require('gitsigns-yadm').yadm_signs(callback)
    end,
    on_attach = function(bufnr)
      vim.keymap.set(
        'n',
        '<leader>hp',
        require('gitsigns').preview_hunk,
        { buffer = bufnr, desc = 'Preview git hunk' }
      )

      -- don't override the built-in and fugitive keymaps
      local gs = package.loaded.gitsigns
      vim.keymap.set({ 'n', 'v' }, ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
      vim.keymap.set({ 'n', 'v' }, '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
    end,
  },
}
