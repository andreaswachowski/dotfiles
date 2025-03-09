setl textwidth=72
setl formatoptions+=a " [fo-a] automatic formatting of paragraphs
setl formatoptions+=w " [fo-w] trailing white space indicates a paragraph continues in the next line.
setl formatoptions+=n " [fo-n] recognize lists (formatlistpat)
" Disable q, otherwise vim cannot format *-bullet points https://superuser.com/a/238883
setl formatoptions-=q
setl comments+=nb:> " that lines starting with > are comments
match ErrorMsg '\s\+$' " highlight the trailing space at the end of broken lines, to provide a visual distinction between “soft” and “hard” line breaks
