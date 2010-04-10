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

imap ó \'o
imap ò \`o
imap ô \^o

imap ú \'u
imap ù \`u
imap û \^u

imap ¢ \c{c}

