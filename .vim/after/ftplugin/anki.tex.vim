" Use these mappings in conjunction with 
" http://www2.math.uni-wuppertal.de/~zibrowiu/LatexNoteImporter/

iab <buffer> No \begin{note}
iab <buffer> Fi \begin{field}
iab <buffer> Xf \xfield{}<Left><C-R>=Eatchar('\s')<CR>
iab <buffer> Pl \begin{plain}
iab <buffer> Xp \xplain{}<Left><C-R>=Eatchar('\s')<CR>

let g:syntastic_quiet_messages = { "regex":
			\'\(Command terminated with space\)
			\\|\(Wrong length of dash may have been used\)' }