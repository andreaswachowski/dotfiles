" g:loaded_tagbar is not set, even though the bundle is installed.
" Perhaps because NERDTree is loaded, too? Anyway, commenting out the if for now
" if exists('g:loaded_tagbar')
  let g:tagbar_left = 1
  nnoremap <silent> <F10> :TagbarToggle<CR>
"endif
