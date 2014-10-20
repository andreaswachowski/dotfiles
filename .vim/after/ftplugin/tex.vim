" LaTeX
map <buffer> _l :w:!latex %
set tw=75

ia <buffer> itm \begin{itemize}\end{itemize}O\item
ia <buffer> enm \begin{enumerate}\end{enumerate}O\item
" New enViRonment
ia <buffer> nvr \begin{}\item \end{}-f}i
" Begin DisplayMath
ia <buffer> bdm \begin{displaymath}\end{displaymath}O
" SubSubSection
ia <buffer> sss \subsubsection{}i

iab <buffer> em {\em \/}<Left><Left><Left><C-R>=Eatchar('\s')<CR>

set comments=:%,b:\\item
set formatoptions=tro

" Klammern und Backslash f�r dt. Tastatur
" n�tzlich beim Schreiben fremdsprachiger Texte, wenn die Umlaute
" eh nicht gebraucht werden.
imap � {
imap � }
imap � [
imap � ]
imap � \

" Umlaute und Sonderzeichen
imap � \'a
imap � \`a
imap � \^a

imap � \'e
imap � \`e
imap � \^e

imap � \^i

imap <buffer> � \'o
imap <buffer> � \`o
imap <buffer> � \^o

imap <buffer> � \'u
imap <buffer> � \`u
imap <buffer> � \^u

imap <buffer> � \c{c}

au BufEnter */fortbildung/*/anki.tex so <sfile>:h/anki.tex.vim
au BufEnter */fortbildung/*/notes.tex so <sfile>:h/notes_for_videos.tex.vim
