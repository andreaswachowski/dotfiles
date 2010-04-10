set showmatch
set tabstop=2
set shiftwidth=2
set expandtab

function! Rspec()
  execute "!spec ".bufname("%")." -l ".search("^ *specify","bc")
endfunction
com! -nargs=0 Rspec call Rspec()

function! RspecFile()
  execute "!spec ".bufname("%")
endfunction
com! -nargs=0 RspecFile call RspecFile()

function! RRestartWebserver()
  execute "!mongrel_restart.sh"
endfunction
com! -nargs=0 RRestartWebserver call RRestartWebserver()

function! RRestartSearchEngine()
  execute "!ruby ~/xing/marketplace/script/xing_remote_search restart ~/xing/marketplace/tmp/indices/postings"
endfunction
com! -nargs=0 RRestartSearchEngine call RRestartSearchEngine()

function! RRestartMemcached()
  execute "!memcached_restart.sh"
endfunction
com! -nargs=0 RRestartMemcached call RRestartMemcached()

runtime after/ftplugin/ruby-block-conv.txt

let g:rubycomplete_rails = 1
