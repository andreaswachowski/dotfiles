let test#strategy = "asyncrun"
autocmd FileType c,cpp,ruby,javascript,typescript,javascriptreact,typescriptreact nnoremap <buffer> <leader>t :TestNearest<CR>
autocmd FileType c,cpp,ruby,javascript,typescript,javascriptreact,typescriptreact nnoremap <buffer> <leader>T :TestFile<CR>
autocmd FileType c,cpp,ruby,javascript,typescript,javascriptreact,typescriptreact nnoremap <buffer> <leader>a :TestSuite<CR>
autocmd FileType c,cpp,ruby,javascript,typescript,javascriptreact,typescriptreact nnoremap <buffer> <leader>l :TestLast<CR>
autocmd FileType c,cpp,ruby,javascript,typescript,javascriptreact,typescriptreact nnoremap <buffer> <leader>g :TestVisit<CR>
