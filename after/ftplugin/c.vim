set showmatch
set tabstop=2
set shiftwidth=2
set expandtab

" mf = Make file:
cmap \mf   cd libdss<CR>:make <C-R>=expand("%:r")<CR>_dll.o<CR>:cd -<CR>

set makeprg=dmake

" Simpler input for accolades on a German keyboard
imap ö {
imap ä }

" Getters, setters (see vimtips.txt Tip 288, adapted to fit C++):
" This mapping assumes that the member does not have an underscore at
" the end yet, and it adds this trailing underscore and the leading underscore
" for a function parameter according to LibDSS coding guidelines
" map cgs ma"tyEW"nyeea_<Esc>/getters<Enter>$a<Enter><Esc>bDa<Enter> <BS><Esc>"tpa <Esc>"npbiget<Esc>l~ea() const<Enter>{<Enter><Tab>return <Esc>"npa_;<Enter>}<Esc>/setters<Enter>$a<Enter><Esc>bDa<Enter>void <Esc>"npbiset<Esc>l~ea(const <Esc>"tpa& _<Esc>"npa)<Enter>{<Enter><Tab><Esc>"npa_ = _<Esc>"npa;<Enter>}<Esc>=<Enter>`ak

" See ftplugin/c/doc/lh-cpp-readme.txt:
" Insert newline before curly bracket during expansion of if-etc. abbreviations
let g:c_nl_before_curlyB = 1

imap <C-J>	<Plug>MarkersJumpF
map <C-J>	<Plug>MarkersJumpF
imap <C-K>	<Plug>MarkersJumpB
map <C-K>	<Plug>MarkersJumpB
imap <C-<>	<Plug>MarkersMark
vmap <C-<>	<Plug>MarkersMark

" Replace function declaration with implementation
" :.,$s/\([^ ]*::[^)]*)\)\( .*;\)/\1\2{  ENTER("\1");}
