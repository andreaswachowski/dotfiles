nmap <silent> <buffer>  <Leader>tc
\	:call taskpaper#toggle_tag('created', taskpaper#date())<CR>

setlocal ts=2
setlocal sw=2
setlocal noexpandtab
setlocal tw=0
setlocal nosmarttab
setlocal breakindent
setlocal briopt=shift:2
