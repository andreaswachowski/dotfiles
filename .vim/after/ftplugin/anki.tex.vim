" Use these mappings in conjunction with 
" http://www2.math.uni-wuppertal.de/~zibrowiu/LatexNoteImporter/

iab <buffer> No \begin{note}\end{note}<Up><Tab><C-R>=Eatchar('\s')<CR>
iab <buffer> Fi \begin{field}\end{field}<Up><Tab><Tab><C-R>=Eatchar('\s')<CR>
iab <buffer> Xf \xfield{}<Left><C-R>=Eatchar('\s')<CR>
iab <buffer> Pl \begin{plain}\end{plain}<Up><Tab><Tab><C-R>=Eatchar('\s')<CR>
iab <buffer> Xp \xplain{}<Left><C-R>=Eatchar('\s')<CR>
iab <buffer> cbx \begin{codebox}\end{codebox}<Up><Tab><Tab><C-R>=Eatchar('\s')<CR>

let g:syntastic_quiet_messages = { "regex":
			\'\(Command terminated with space\)
			\\|\(Wrong length of dash may have been used\)' }
