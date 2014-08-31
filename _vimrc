set nocompatible
filetype off

source ~/.vim/bundles.vim

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" -- General settings -----------------------------------------------------
set sessionoptions-=optins

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
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
set laststatus=2
set diffopt=filler,vertical

let g:netrw_alto = 1 " split below the file browser

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
  " desert256's original comment color is darkcyan, which is too dark on a
  " black background. Changing to cyan:
  hi Comment       ctermfg=cyan
elseif &t_Co >= 88
  colorscheme desert256
"  colorscheme inkpot
  " desert256's original comment color is darkcyan, which is too dark on a
  " black background. Changing to cyan:
  hi Comment       ctermfg=cyan
endif
if has("gui_running")
  set guioptions-=m " remove menu bar
  set guioptions-=T " remove tool bar
endif

" Using "ctermbg=White" will only use gray background on an iTerm with 256
" colors, therefore using 255 instead.
highlight Visual term=reverse ctermbg=255 guibg=White

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

" Overriding a few VCSCommands with fugitive equivalents
nmap \cs :Gstatus
nmap \cv :Gdiff
nmap \cl :Glog
nmap \cb :Gblame

" vi:expandtab ts=2 sw=2
set modeline
let g:GetLatestVimScripts_allowautoinstall=1

" ViM autocommands for binary plist files
" Copyright (C) 2005 Moritz Heckscher
"
" Note: When a file changes externally and you answer no to vim's question if
" you want to write anyway, the autocommands (e.g. for BufWritePost) are still
" executed, it seems, which could have some unwanted side effects.
"
" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
augroup plist
  " Delete existing commands (avoid problems if this file is sourced twice)
  autocmd!

  " Set binary mode (needs to be set _before_ reading binary files to avoid
  " breaking lines etc; since setting this for normal plist files doesn't
  " hurt and it's not yet known whether or not the file to be read is stored
  " in binary format, set the option in any case to be sure).
  " Do it before editing a file in a new buffer and before reading a file
  " into in an existing buffer (using ':read foo.plist').
  autocmd BufReadPre,FileReadPre *.plist set binary

  " Define a little function to convert binary files if necessary...
  fun MyBinaryPlistReadPost()
          " Check if the first line just read in indicates a binary plist
          if getline("'[") =~ "^bplist"
                  " Filter lines read into buffer (convert to XML with plutil)
                  '[,']!plutil -convert xml1 /dev/stdin -o /dev/stdout
                  " Many people seem to want to save files originally stored
                  " in binary format as such after editing, so memorize format.
                  let b:saveAsBinaryPlist = 1
          endif
          " Yeah, plain text (finally or all the way through, either way...)!
          set nobinary
          " Trigger file type detection to get syntax coloring etc. according
          " to file contents (alternative: 'setfiletype xml' to force xml).
          filetype detect
  endfun
  " ... and call it just after editing a file in a new buffer...
  autocmd BufReadPost *.plist call MyBinaryPlistReadPost()
  " ... or when reading a file into an existing buffer (in that case, don't
  " save as binary later on).
  autocmd FileReadPost *.plist call MyBinaryPlistReadPost() | let b:saveAsBinaryPlist = 0

  " Define and use functions for conversion back to binary format
  fun MyBinaryPlistWritePre()
          if exists("b:saveAsBinaryPlist") && b:saveAsBinaryPlist
                  " Must set binary mode before conversion (for EOL settings)
                  set binary
                  " Convert buffer lines to be written to binary
                  silent '[,']!plutil -convert binary1 /dev/stdin -o /dev/stdout
                  " If there was a problem, e.g. when the file contains syntax
                  " errors, undo the conversion and go back to nobinary so the
                  " file will be saved in text format.
                  if v:shell_error | undo | set nobinary | endif
          endif
  endfun
  autocmd BufWritePre,FileWritePre *.plist call MyBinaryPlistWritePre()
  fun MyBinaryPlistWritePost()
          " If file was to be written in binary format and there was no error
          " doing the conversion, ...
          if exists("b:saveAsBinaryPlist") && b:saveAsBinaryPlist && !v:shell_error
                  " ... undo the conversion and go back to nobinary so the
                  " lines are shown as text again in vim.
                  undo
                  set nobinary
          endif
  endfun
  autocmd BufWritePost,FileWritePost *.plist call MyBinaryPlistWritePost()
augroup END

if has("multi_byte")
	if &termencoding == ""
		let &termencoding = &encoding
	endif
	set encoding=utf-8                     " better default than latin1
	setglobal fileencoding=utf-8           " change default file encoding when writing new files
endif
set encoding=utf-8                     " better default than latin1
set fileencoding=utf-8                     " better default than latin1
setglobal fileencoding=utf-8           " change default file encoding when writing new files
