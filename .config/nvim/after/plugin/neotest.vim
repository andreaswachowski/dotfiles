autocmd FileType c,cpp,ruby,javascript,typescript,javascriptreact,typescriptreact nnoremap <buffer> <leader>t :lua require("neotest").run.run()<CR>
autocmd FileType c,cpp,ruby,javascript,typescript,javascriptreact,typescriptreact nnoremap <buffer> <leader>T :lua require("neotest").run.run(vim.fn.expand("%"))<CR>
autocmd FileType c,cpp,ruby,javascript,typescript,javascriptreact,typescriptreact nnoremap <buffer> <leader>d :lua require("neotest").run.run({strategy = "dap"})<CR>
autocmd FileType c,cpp,ruby,javascript,typescript,javascriptreact,typescriptreact nnoremap <buffer> <leader>o :lua require("neotest").output_panel.toggle()<CR>
autocmd FileType c,cpp,ruby,javascript,typescript,javascriptreact,typescriptreact nnoremap <buffer> <leader>s :lua require("neotest").run.stop()<CR>
