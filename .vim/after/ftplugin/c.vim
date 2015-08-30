" set showmatch
" set makeprg=dmake

" Simpler input for accolades on a German keyboard
imap ö {
imap ä }

" Getters, setters (see vimtips.txt Tip 288, adapted to fit C++):
" This mapping assumes that the member does not have an underscore at
" the end yet, and it adds this trailing underscore and the leading underscore
" for a function parameter according to LibDSS coding guidelines
" map cgs ma"tyEW"nyeea_<Esc>/getters<Enter>$a<Enter><Esc>bDa<Enter> <BS><Esc>"tpa <Esc>"npbiget<Esc>l~ea() const<Enter>{<Enter><Tab>return <Esc>"npa_;<Enter>}<Esc>/setters<Enter>$a<Enter><Esc>bDa<Enter>void <Esc>"npbiset<Esc>l~ea(const <Esc>"tpa& _<Esc>"npa)<Enter>{<Enter><Tab><Esc>"npa_ = _<Esc>"npa;<Enter>}<Esc>=<Enter>`ak

" imap <C-J>	<Plug>MarkersJumpF
" map <C-J>	<Plug>MarkersJumpF
" imap <C-K>	<Plug>MarkersJumpB
" map <C-K>	<Plug>MarkersJumpB
" imap <C-<>	<Plug>MarkersMark
" vmap <C-<>	<Plug>MarkersMark

" Automatically remove trailing spaces before writing the file
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
autocmd BufWritePre *.c :%s/\s\+$//e
