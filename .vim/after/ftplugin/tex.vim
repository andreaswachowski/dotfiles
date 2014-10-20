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

" Klammern und Backslash für dt. Tastatur
" nützlich beim Schreiben fremdsprachiger Texte, wenn die Umlaute
" eh nicht gebraucht werden.
imap ö {
imap ä }
imap Ö [
imap Ä ]
imap ü \

" Umlaute und Sonderzeichen
imap á \'a
imap à \`a
imap â \^a

imap é \'e
imap è \`e
imap ê \^e

imap î \^i

imap <buffer> ó \'o
imap <buffer> ò \`o
imap <buffer> ô \^o

imap <buffer> ú \'u
imap <buffer> ù \`u
imap <buffer> û \^u

imap <buffer> ¢ \c{c}

au BufEnter */fortbildung/*/anki.tex so <sfile>:h/anki.tex.vim
au BufEnter */fortbildung/*/notes.tex so <sfile>:h/notes_for_videos.tex.vim
