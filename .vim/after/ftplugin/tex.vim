" LaTeX
map _l :w:!latex %
set tw=75

"ITeMize
ia itm \begin{itemize}\end{itemize}O\item
" New enViRonment
ia nvr \begin{}\item \end{}-f}i
" Begin DisplayMath
ia bdm \begin{displaymath}\end{displaymath}O
" SubSubSection
ia sss \subsubsection{}i


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

imap � \'o
imap � \`o
imap � \^o

imap � \'u
imap � \`u
imap � \^u

imap � \c{c}

