" set the runtime path to include Vundle and initialize
" vi: ts=2 sw=2 expandtab
set rtp+=~/.vim/bundle/Vundle.vim

if hostname() =~ "salt" || hostname() =~ "macbook"
  let s:development="true"
else
  let s:development="false"
endif

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-bundler'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'int3/vim-extradite'
Plugin 'vcscommand.vim'
Plugin 'mileszs/ack.vim'
Plugin 'freitass/todo.txt-vim'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-unimpaired'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'vim-scripts/DirDiff.vim'

if (s:development=="true")
  Plugin 'vim-ruby/vim-ruby'
  Plugin 'dbext.vim'
  Plugin 'taglist.vim'
  Plugin 'TVO--The-Vim-Outliner'
  Plugin 'tpope/vim-rails'
  Plugin 'sukima/xmledit'
  Plugin 'bolasblack/csslint.vim'

  " JavaScript, see
  " http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/
  Plugin 'jelera/vim-javascript-syntax'
  Plugin 'pangloss/vim-javascript'
  Plugin 'nathanaelkane/vim-indent-guides'
  Plugin 'scrooloose/syntastic'
  Plugin 'Valloric/YouCompleteMe'
  Plugin 'marijnh/tern_for_vim'

  Plugin 'tomtom/tlib_vim'
  Plugin 'MarcWeber/vim-addon-mw-utils'
  Plugin 'garbas/vim-snipmate'
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
