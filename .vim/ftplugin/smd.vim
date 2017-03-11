" Fileytpe plugin for Supermemo databases (http://www.mapletop.com)
" These are actually CSV-files. I want a specific setting to better
" handle long question/answer pairs.
setlocal nowrap
setlocal guifont="Monospace 9"
setlocal ts=70
setlocal sw=70
setlocal tw=0
setlocal noexpandtab
setlocal list
" Supermemo does only handle latin1, not UTF-8. Upon saving the file,
" we convert thus to latin1:
setlocal fileencoding=latin1

iab cmv <tab><tab><tab><tab>Class, Method, and Variable Modifiers
iab oa <tab><tab><tab><tab>Operators and Assignments
