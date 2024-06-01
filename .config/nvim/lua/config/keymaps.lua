-- Vim Tip 173: Quick movement between split windows
-- https://vim.fandom.com/wiki/Switch_between_Vim_window_splits_easily
local opts = { noremap = true, silent = true }

-- neovim has "nnoremap Y y$" (see default-mappings), undo that
vim.keymap.del('n', 'Y')

-- copy path of current buffer
-- https://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
vim.keymap.set('n', 'cp', ':let @" = expand(\'%\')<cr>', opts)

-- control split sizes

if (vim.loop.os_uname().sysname == 'Darwin') then
  -- https://stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim#15399297
  -- With iTerm2 and option keys configured to "normal", one must actually press
  -- the key to generate the character, then map that.
  -- I cannot use the above solution because it prevents me from typing umlauts.
  vim.keymap.set('n', '≤', '<c-w>5<', opts) -- <M-,>
  vim.keymap.set('n', '≥', '<c-w>5>', opts) -- <M-.>
  vim.keymap.set('n', '…', '<c-w>+', opts) -- <M-;>
  vim.keymap.set('n', '÷', '<c-w>-', opts) -- <T-/>
else
  -- On Macos, on iTerm, these settings would require
  -- iTerm2 -> Profiles -> Edit -> Keys -> Left/Right Option key == Esc+ !
  -- ("Normal" and "Meta" do not work)
  -- BUT with ESC+, Umlauts cannot be typed anymore.
  vim.keymap.set('n', '<M-,>', '<c-w>5<', opts)
  vim.keymap.set('n', '<M-.>', '<c-w>5>', opts)
  vim.keymap.set('n', '<M-;>', '<c-w>+', opts)
  vim.keymap.set('n', '<M-/>', '<c-w>-', opts)
end

-- Diagnostic keymaps
vim.keymap.set( 'n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('n', '<F5>', function() require('osv').launch({port = 8086}) end)
vim.keymap.set('n', '<F9>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() require('dap.ui.widgets').hover() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function() require('dap.ui.widgets').preview() end)
vim.keymap.set('n', '<Leader>df', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.frames) end)
vim.keymap.set('n', '<Leader>ds', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.scopes) end)
