if exists('g:load_black')
  autocmd BufWritePre *.py execute ':Black'
endif
