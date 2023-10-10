" https://github.com/tpope/vim-rails/issues/503#issuecomment-1158877143
command AC :execute "e " . eval('rails#buffer().alternate()')
