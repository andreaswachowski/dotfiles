" -- General settings -----------------------------------------------------
let s:host_specific_pre_setup = expand("<sfile>").".host.pre.".hostname()
if findfile(s:host_specific_pre_setup,"<sfile>:%h") != ""
  source `=expand(s:host_specific_pre_setup)`
endif
unlet s:host_specific_pre_setup

if &term =~ "dtterm" 
  set t_Co=256
elseif &term =~ "xterm-256color"
  set t_Co=256
elseif  &term =~ "rxvt-unicode"
  set t_Co=88
"2010-04-03: The following two lines don't help on Linux - my term is
"xterm, and I have 256 colors there. Will have to adapt this to work on all
"machines; in the meantime just commenting it out.
"elseif &term =~ "xterm"
"  set t_Co=8
endif

if &term =~ "dtterm" || &term =~ "xterm"|| &term =~ "rxvt-unicode"
  if has("terminfo")
    set t_Sf=<Esc>[3%p1%dm
   set t_Sb=<Esc>[4%p1%dm
 else
   set t_Sf=<Esc>[3%dm
   set t_Sb=<Esc>[4%dm
 endif
endif

set nohlsearch
set visualbell
set autoindent
set incsearch
set sidescroll=1
" FIXME:exrc is not necessary if I am in $HOME/.vim
" Then, the whole configuration will be sourced twice.
set exrc " enable reading of local .vimrc and .exrc files
set winminheight=0 " minimize a window to just its status bar
set textwidth=75
set statusline=%f%m%=%l:%c
set diffopt=filler,vertical

let g:netrw_alto = 1 " split below the file browser
filetype plugin indent on

au BufReadPost quickfix  set nowrap

if &t_Co > 2 || has("gui_running")
  syntax on
  highlight Statement ctermfg=1
endif
if &t_Co >= 256 || has("gui_running")
" 2010-04-03 Switched to a black desktop theme where a black colorscheme is
" needed, therefore using desert256 now.
" colorscheme default256
  colorscheme desert256
elseif &t_Co >= 88
  colorscheme desert256
"  colorscheme inkpot
endif
if has("gui_running")
  set guioptions-=m " remove menu bar
  set guioptions-=T " remove tool bar
endif

" Using "ctermbg=White" will only use gray background on an iTerm with 256
" colors, therefore using 255 instead.
highlight Visual term=reverse ctermbg=255 guibg=White

" filetype for Supermemo Databases:
au BufRead,BufNewFile *.smd		setfiletype smd

source <sfile>.handling_gzip
source <sfile>.tip343_large_files
source <sfile>.tip112_indentation_helper

" -- OS-specific settings -------------------------------------------------
let s:os = "unknown"
if has("mac")
  let s:os="mac"
elseif has("unix")
  let s:os="unix"
elseif has("win32")
  let s:os="win32"
" else nothing specific to be done.
endif
if s:os != "unknown"
  let s:os_specific_setup = expand("<sfile>").".os.".s:os
  if findfile(s:os_specific_setup,"<sfile>:%h") != ""
    source `=expand(s:os_specific_setup)`
  endif
  unlet s:os_specific_setup
endif
unlet s:os

" -- host-specific settings -----------------------------------------------
let s:host_specific_setup = expand("<sfile>").".host.".hostname()
if findfile(s:host_specific_setup,"<sfile>:%h") != ""
  source `=expand(s:host_specific_setup)`
endif
unlet s:host_specific_setup

" Vim Tip 173: Quick movement between split windows
nmap <c-l> <c-w>l
nmap <c-h> <c-w>h
nmap <c-k> <c-w>k
nmap <c-j> <c-w>j

:hi Comment	term=bold ctermfg=LightBlue guifg=#80a0ff gui=bold
" vi:expandtab ts=2 sw=2
set modeline
let g:GetLatestVimScripts_allowautoinstall=1
