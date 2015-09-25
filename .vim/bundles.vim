" set the runtime path to include Vundle and initialize
" vi: ts=2 sw=2 expandtab
set rtp+=~/.vim/bundle/Vundle.vim

if (hostname() =~ "salt" || hostname() =~ "macbook" || hostname() =~ "MacBookPro" ) && ($USER == "andreas")
  let s:development="true"
else
  let s:development="false"
endif

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-obsession'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-bundler'
" Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-unimpaired'
Plugin 'int3/vim-extradite'
Plugin 'vcscommand.vim'
Plugin 'mileszs/ack.vim'
Plugin 'freitass/todo.txt-vim'
Plugin 'Raimondi/delimitMate'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'vim-scripts/DirDiff.vim'
" tlib is required by tskeleton
Plugin 'tomtom/tlib_vim'
Plugin 'tomtom/tskeleton_vim'
Plugin 'sukima/xmledit'
Plugin 'davidoc/taskpaper.vim'

if (s:development=="true")
  Plugin 'tpope/vim-dispatch'
  Plugin 'majutsushi/tagbar'
  Plugin 'scrooloose/nerdcommenter'

  Plugin 'dbext.vim'
  Plugin 'TVO--The-Vim-Outliner'

  Plugin 'vim-ruby/vim-ruby'
  " Plugin 'thoughtbot/vim-rspec'
  Plugin 'tpope/vim-rails'

  Plugin 'hail2u/vim-css3-syntax'
  Plugin 'cakebaker/scss-syntax.vim'
  Plugin 'bolasblack/csslint.vim'
  " Plugin 'groenewege/vim-less'

  Plugin 'tpope/vim-haml'
  Plugin 'mustache/vim-mustache-handlebars'

  Plugin 'mhinz/vim-rfc'
  Plugin 'vim-scripts/rfc-syntax'
  Plugin 'kana/vim-tabpagecd'
  Plugin 'greyblake/vim-preview'

  " JavaScript, see
  " http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/
  Plugin 'jelera/vim-javascript-syntax'
  Plugin 'pangloss/vim-javascript'
  Plugin 'nathanaelkane/vim-indent-guides'
  Plugin 'scrooloose/syntastic'
  Plugin 'Valloric/YouCompleteMe'
  Plugin 'marijnh/tern_for_vim'

  Plugin 'MarcWeber/vim-addon-mw-utils'
  Plugin 'garbas/vim-snipmate'

  Plugin 'vim-scripts/ingo-library'
  Plugin 'vim-scripts/IndentConsistencyCop'
  Plugin 'vim-scripts/IndentConsistencyCopAutoCmds'
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
