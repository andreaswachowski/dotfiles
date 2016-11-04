" vi: ts=2 sw=2 expandtab

if (hostname() =~ "salt" || hostname() =~ "macbook" || hostname() =~ "MacBookPro" ) && ($USER == "andreas")
  let s:development="true"
else
  let s:development="false"
endif

call plug#begin()
Plug 'morhetz/gruvbox'

Plug 'tpope/vim-obsession'
" Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-bundler'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-unimpaired'
Plug 'int3/vim-extradite'
Plug 'vcscommand.vim'
Plug 'mileszs/ack.vim'
Plug 'Raimondi/delimitMate'
Plug 'jlanzarotta/bufexplorer'
Plug 'vim-scripts/DirDiff.vim'
Plug 'sukima/xmledit'
Plug 'davidoc/taskpaper.vim'

Plug 'suan/vim-instant-markdown'

if (s:development=="true")
  Plug 'editorconfig/editorconfig-vim'
  Plug 'tpope/vim-dispatch'
  Plug 'majutsushi/tagbar'
  Plug 'scrooloose/nerdcommenter'
  Plug 'rizzatti/dash.vim'

  Plug 'vim-syntastic/syntastic'
  Plug 'Valloric/YouCompleteMe'

  Plug 'dbext.vim'
  Plug 'TVO--The-Vim-Outliner'

  " Ruby etc.
  Plug 'tpope/vim-rvm'
  Plug 'vim-ruby/vim-ruby'
  Plug 'thoughtbot/vim-rspec'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-endwise'

  " CSS related bundles
  Plug 'hail2u/vim-css3-syntax'
  Plug 'cakebaker/scss-syntax.vim'
  Plug 'bolasblack/csslint.vim'
  " Plug 'groenewege/vim-less'
  Plug 'wavded/vim-stylus'

  " Templating engines
  Plug 'tpope/vim-haml'
  Plug 'slim-template/vim-slim'
  Plug 'mustache/vim-mustache-handlebars'
  Plug 'digitaltoad/vim-jade'
  Plug 'tpope/vim-liquid'

  Plug 'mhinz/vim-rfc'
  Plug 'vim-scripts/rfc-syntax'
  Plug 'kana/vim-tabpagecd'
  Plug 'greyblake/vim-preview'

  " http://stackoverflow.com/questions/14896327/ultisnips-and-youcompleteme
  Plug 'ervandew/supertab'
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

  " JavaScript, see
  " http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/
  Plug 'jelera/vim-javascript-syntax'
  Plug 'pangloss/vim-javascript'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'marijnh/tern_for_vim'
  Plug 'mtscout6/syntastic-local-eslint.vim'
  Plug 'isRuslan/vim-es6'

  Plug 'mxw/vim-jsx'
  Plug 'justinj/vim-react-snippets'

  Plug 'kchmck/vim-coffee-script'

  " Z80 Assembly
  Plug 'cpcsdk/vim-z80-democoding'

  Plug 'vim-scripts/ingo-library'
  Plug 'vim-scripts/IndentConsistencyCop' | Plug 'vim-scripts/IndentConsistencyCopAutoCmds'
endif

call plug#end()
