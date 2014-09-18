:nmap <Leader>j :make<CR>
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
set wildignore+=*.aux,*.dvi,*.out,*.log,*.pdf

" I know how to use LaTeX dashes
let g:syntastic_quiet_messages = { "regex": 'Wrong length of dash may have been used' }

" Use these mappings in conjunction with 
" http://www2.math.uni-wuppertal.de/~zibrowiu/LatexNoteImporter/
if expand('%:t')== "anki.tex"
	func! Eatchar(pat)
		let c = nr2char(getchar(0))
		return (c =~ a:pat) ? '' : c
	endfunc
	"iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>
	" let @n = 'o\begin{note}\end{note}O'
	" let @f = 'o\begin{field}\end{field}O'
	iab <silent> No \begin{note}\end{note}<Up><Tab><C-R>=Eatchar('\s')<CR>
	iab <silent> Fi \begin{field}\end{field}<Up><Tab><Tab><C-R>=Eatchar('\s')<CR>
	iab <silent> Xf \xfield{}<Left><C-R>=Eatchar('\s')<CR>
	iab <silent> Pl \begin{plain}\end{plain}<Up><Tab><C-R>=Eatchar('\s')<CR>
	iab <silent> Xp \xplain{}<Left><C-R>=Eatchar('\s')<CR>

	let g:syntastic_quiet_messages = { "regex":
				\'\(Command terminated with space\)
				\\|\(Wrong length of dash may have been used\)' }
endif

