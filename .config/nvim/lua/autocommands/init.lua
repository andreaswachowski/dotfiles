require('autocommands.git')
require('autocommands.mail')
require('autocommands.ruby')
require('autocommands.telescope')
require('autocommands.ruby_stacktrace')
vim.cmd([[autocmd FileType json,html,xml,yaml set tabstop=2 shiftwidth=2 expandtab]])

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'text,mail',
  callback = function()
    vim.opt_local.formatoptions:append('n') -- [fo-n] recognize lists (formatlistpat)
    vim.opt_local.formatoptions:remove('q') -- [fo-n] recognize lists (formatlistpat)
    vim.opt_local.autoindent = true
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'text,mail',
  callback = function() vim.opt_local.formatlistpat = [[^\s*\(\d\+[):.}]\|[*-]\)\s*]] end,
})

-- Set correct filetype for podman quadlet extensions
vim.filetype.add({
  extension = {
    build = 'systemd',
    container = 'systemd',
    image = 'systemd',
    kube = 'systemd',
    network = 'systemd',
    volume = 'systemd',
    pod = 'systemd',
  },
})
