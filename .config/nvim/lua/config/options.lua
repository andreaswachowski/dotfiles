-- See `:help vim.o`

vim.o.breakindent = true

-- use vertical diff
vim.o.diffopt = "internal,algorithm:patience,filler,closeoff,vertical"

--neovim's thin bar becomes black and invisible, use block cursor instead
vim.o.guicursor = "i-ci-ve:block"

vim.o.hlsearch = false    -- Set highlight on search
vim.o.mouse = 'a'         -- enable mouse mode
vim.o.number = true       -- line numbers helps during pair programming
vim.wo.signcolumn = 'yes' -- otherwise too distracting with gitsigns
vim.o.termguicolors = true
vim.o.textwidth = 80      -- keep to "sane" width unless explicitly overridden
vim.o.tildeop = true
vim.o.timeoutlen = 300    -- wait for a mapped sequence to complete, default 1000
vim.o.undofile = true
vim.o.updatetime = 500    -- delay after swap file is written, default 4000
vim.o.visualbell = true
vim.cmd([[set wildignore+=*.jpg,*.png,*.o]])
-- vim.o.wildignore:append{'*.jpg', '*.png', '*.o'} doesn't work when
-- wildignore is empty
vim.o.winminheight = 0 -- minimize a window to just its status bar

--[[ Store temporary files in a central spot to ease
     clean-up after machine crashes
     https://github.com/tpope/vim-obsession/issues/18]]
vim.cmd([[
let vimtmp = $HOME . '/tmp/vim/' . getpid()
silent! call mkdir(vimtmp, "p", 0700)
let &backupdir=vimtmp
let &directory=vimtmp
]])
