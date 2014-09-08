" Fileytpe plugin for Supermemo databases (http://www.mapletop.com)
" These are actually CSV-files. I want a specific setting to better
" handle long question/answer pairs.
set nowrap
set guifont="Monospace 9"
set ts=70
set sw=70
set tw=0
set noexpandtab
set list
" Supermemo does only handle latin1, not UTF-8. Upon saving the file,
" we convert thus to latin1:
set fileencoding=latin1

iab cmv <tab><tab><tab><tab>Class, Method, and Variable Modifiers
iab oa <tab><tab><tab><tab>Operators and Assignments
