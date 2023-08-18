" vi: ts=2 sw=2 expandtab

" download vim-plug if missing
if empty(glob("~/.vim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fsSLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

if filereadable(expand("$HOME/.vim/.plugs_for_dev"))
  let s:development="true"
else
  let s:development="false"
endif

call plug#begin()
Plug 'morhetz/gruvbox'

Plug 'vimwiki/vimwiki'
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
Plug 'mhinz/vim-grepper'
Plug 'Raimondi/delimitMate'
Plug 'vim-scripts/DirDiff.vim'
Plug 'sukima/xmledit'
Plug 'andreaswachowski/taskpaper.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'benmills/vimux'
Plug 'mbbill/undotree'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

if (s:development=="true")
  if has('nvim')
    Plug 'floobits/floobits-neovim'
  endif
  Plug 'junegunn/vader.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-dadbod'
  Plug 'tpope/vim-abolish'
  Plug 'kristijanhusak/vim-dadbod-ui'
  " Plug 'kristijanhusak/vim-dadbod-completion'
  Plug 'majutsushi/tagbar'
  " Plug 'rizzatti/dash.vim'
  Plug 'Yggdroot/indentLine'

  " Plug 'ludovicchabant/vim-gutentags'

  Plug 'dense-analysis/ale'
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --ts-completer' }
  Plug 'sheerun/vim-polyglot'

  Plug 'docunext/closetag.vim'

  " Ruby etc.
  " Plug 'tpope/vim-rvm'
  Plug 'vim-test/vim-test'
  " Plug 'thoughtbot/vim-rspec'
  Plug 'tpope/vim-rails'
  " Using https://github.com/lzap/gem-ripper-tags instead of gem-ctags
  " Plug 'tpope/gem-ctags'
  Plug 'tpope/vim-endwise'

  " CSS related bundles
  Plug 'hail2u/vim-css3-syntax'

  Plug 'mhinz/vim-rfc'
  Plug 'vim-scripts/rfc-syntax'
  Plug 'kana/vim-tabpagecd'

  " http://stackoverflow.com/questions/14896327/ultisnips-and-youcompleteme
  Plug 'ervandew/supertab'
  " if neovim complains about a missing python3 provider, try
  " python3 -m pip install --user --upgrade pynvim
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
