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
  -- Patches a race condition in gitsigns' async attach flow: if a buffer is
  -- wiped (e.g. orgmode refile/archive force-wiping its scratch buffer)
  -- while gitsigns is suspended awaiting `_on_attach_pre`, it resumes and
  -- crashes with "Invalid buffer id" at attach.lua:306. gitsigns already
  -- re-validates the buffer after its two other yield points in the same
  -- function (attach.lua:334-338, 372-376) -- this adds the missing check
  -- after the third. No upstream fix exists yet; drop this once one lands.
  -- Runs automatically after install/update (see lazy.nvim's `plugin.build`
  -- task); run `:Lazy build gitsigns.nvim` to apply immediately.
  build = function(plugin)
    local file = plugin.dir .. '/lua/gitsigns/attach.lua'
    local lines = vim.fn.readfile(file)
    if vim.tbl_isempty(lines) then
      return
    end

    local marker = '-- orgmode-race-fix'
    for _, line in ipairs(lines) do
      if line:find(marker, 1, true) then
        return -- already patched
      end
    end

    local anchor = -1
    for i, line in ipairs(lines) do
      if line:match('^%s*assert%(ctx%)%s*$') and lines[i + 1] and lines[i + 1]:match('^%s*end%s*$') then
        anchor = i + 1
        break
      end
    end

    if anchor == -1 then
      vim.notify(
        'gitsigns orgmode-race-fix: could not find patch anchor in attach.lua, skipping (upstream code may have changed)',
        vim.log.levels.WARN
      )
      return
    end

    local indent = lines[anchor]:match('^(%s*)') or '  '
    local patch = {
      indent .. marker,
      indent .. 'if not api.nvim_buf_is_valid(cbuf) then',
      indent .. '  return',
      indent .. 'end',
    }

    local patched = {}
    for i = 1, anchor do
      table.insert(patched, lines[i])
    end
    vim.list_extend(patched, patch)
    for i = anchor + 1, #lines do
      table.insert(patched, lines[i])
    end

    vim.fn.writefile(patched, file)
  end,
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    _on_attach_pre = function(_, callback) require('gitsigns-yadm').yadm_signs(callback) end,
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
