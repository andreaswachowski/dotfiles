" vi: ts=2 sw=2 expandtab

if filereadable(expand("$HOME/.vim/.plugs_for_dev"))
  let s:development="true"
else
  let s:development="false"
endif

call plug#begin()
Plug 'morhetz/gruvbox'

Plug 'tpope/vim-obsession'
" Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-bundler'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" Plug 'junegunn/gv.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-unimpaired'
Plug 'int3/vim-extradite'
" Plug 'mileszs/ack.vim'
Plug 'Raimondi/delimitMate'
Plug 'vim-scripts/DirDiff.vim'
Plug 'sukima/xmledit'
Plug 'davidoc/taskpaper.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'benmills/vimux'
Plug 'mbbill/undotree'
Plug 'suan/vim-instant-markdown'

if (s:development=="true")
  Plug 'editorconfig/editorconfig-vim'
  Plug 'tpope/vim-dispatch'
  Plug 'majutsushi/tagbar'
  " Plug 'rizzatti/dash.vim'
  Plug 'Yggdroot/indentLine'


  Plug 'w0rp/ale'
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --ts-completer' }
  Plug 'sheerun/vim-polyglot'
  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

  Plug 'vim-scripts/dbext.vim'

  Plug 'docunext/closetag.vim'

  Plug 'prettier/vim-prettier', {
    \ 'do': 'yarn install',
    \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown'] }

  " Ruby etc.
  " Plug 'tpope/vim-rvm'
  " Plug 'thoughtbot/vim-rspec'
  " Plug 'tpope/vim-rails'
  " Plug 'tpope/vim-endwise'

  " CSS related bundles
  Plug 'hail2u/vim-css3-syntax'

  Plug 'mhinz/vim-rfc'
  Plug 'vim-scripts/rfc-syntax'
  Plug 'kana/vim-tabpagecd'

  " http://stackoverflow.com/questions/14896327/ultisnips-and-youcompleteme
  Plug 'ervandew/supertab'
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

  " JavaScript, see
  " http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
  Plug 'isRuslan/vim-es6'

  " React
  Plug 'justinj/vim-react-snippets'
  Plug 'pgilad/vim-react-proptypes-snippets'

	" TypeScript
	Plug 'Shougo/vimproc.vim', { 'do' : 'make', }
  Plug 'Quramy/tsuquyomi' 

  " Z80 Assembly
  " Plug 'cpcsdk/vim-z80-democoding'

  Plug 'vim-scripts/ingo-library'
  " Plug 'vim-scripts/IndentConsistencyCop' | Plug 'vim-scripts/IndentConsistencyCopAutoCmds'
endif

call plug#end()
