" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-fugitive'
Plugin 'dbext.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'taglist.vim'
Plugin 'TVO--The-Vim-Outliner'
Plugin 'vcscommand.vim'
Plugin 'tpope/vim-bundler'
Plugin 'int3/vim-extradite'
Plugin 'tpope/vim-rails'
Plugin 'mileszs/ack.vim'
Plugin 'sukima/xmledit'
Plugin 'bolasblack/csslint.vim'
Plugin 'freitass/todo.txt-vim'

" JavaScript, see
" http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
Plugin 'marijnh/tern_for_vim'

Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'garbas/vim-snipmate'

" All of your Plugins must be added before the following line
call vundle#end()            " required
