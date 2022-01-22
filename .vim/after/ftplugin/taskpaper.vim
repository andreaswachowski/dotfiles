" setlocal foldlevel=20
" setlocal foldcolumn=1			" turns on "+" at the beginning of close folds
" setlocal foldmethod=expr
" setlocal foldexpr=MyFoldLevel(v:lnum)
" setlocal indentexpr=
" setlocal nocindent

" Vim Outliner Functions {{{1

if !exists("loaded_vimoutliner_taskpaper_functions")
let loaded_vimoutliner_taskpaper_functions=1

" Ind(line) {{{2
" Determine the indent level of a line.
" Courtesy of Gabriel Horner
function! Ind(line)
	return indent(a:line)/&tabstop
endfunction
"}}}2
" MakeChars() {{{2
" Make a string of characters
" Used for strings of repeated characters
function MakeChars(count,char)
	let i = 0
	let l:chars=""
	while i < a:count
		let l:chars = l:chars . a:char
		let i = i + 1
	endwhile
	return l:chars
endfunction
"}}}2
" MakeSpaces() {{{2
" Make a string of spaces
function MakeSpaces(count)
	return MakeChars(a:count," ")
endfunction
"}}}2
" MakeDashes() {{{2
" Make a string of dashes
function MakeDashes(count)
	return MakeChars(a:count,"-")
endfunction
"}}}2
" MyFoldText() {{{2
" Create string used for folded text blocks
function! MyFoldText()
    if exists('g:vo_fold_length') && g:vo_fold_length == "max"
        let l:foldlength = winwidth(0) - 1 - &numberwidth - &foldcolumn
    elseif exists('g:vo_fold_length')
        let l:foldlength = g:vo_fold_length
    else
        let l:foldlength = 76
    endif
    " I have this as an option, if the user wants to set "…" as the padding
    " string, or some other string, like "(more)"
    if exists('g:vo_trim_string')
        let l:trimstr = g:vo_trim_string
    else
        let l:trimstr = "..."
    endif
	let l:MySpaces = MakeSpaces(&sw)
	let l:line = getline(v:foldstart)
	let l:bodyTextFlag=0
	if l:line =~ "^\t* \\S" || l:line =~ "^\t*\:"
		let l:bodyTextFlag=1
		let l:MySpaces = MakeSpaces(&sw * (v:foldlevel-1))
		let l:line = l:MySpaces."[TEXT]"
	elseif l:line =~ "^\t*\;"
		let l:bodyTextFlag=1
		let l:MySpaces = MakeSpaces(&sw * (v:foldlevel-1))
		let l:line = l:MySpaces."[TEXT BLOCK]"
	elseif l:line =~ "^\t*\> "
		let l:bodyTextFlag=1
		let l:MySpaces = MakeSpaces(&sw * (v:foldlevel-1))
		let l:line = l:MySpaces."[USER]"
	elseif l:line =~ "^\t*\>"
		let l:ls = stridx(l:line,">")
		let l:le = stridx(l:line," ")
		if l:le == -1
			let l:l = strpart(l:line, l:ls+1)
		else
			let l:l = strpart(l:line, l:ls+1, l:le-l:ls-1)
		endif
		let l:bodyTextFlag=1
		let l:MySpaces = MakeSpaces(&sw * (v:foldlevel-1))
		let l:line = l:MySpaces."[USER ".l:l."]"
	elseif l:line =~ "^\t*\< "
		let l:bodyTextFlag=1
		let l:MySpaces = MakeSpaces(&sw * (v:foldlevel-1))
		let l:line = l:MySpaces."[USER BLOCK]"
	elseif l:line =~ "^\t*\<"
		let l:ls = stridx(l:line,"<")
		let l:le = stridx(l:line," ")
		if l:le == -1
			let l:l = strpart(l:line, l:ls+1)
		else
			let l:l = strpart(l:line, l:ls+1, l:le-l:ls-1)
		endif
		let l:bodyTextFlag=1
		let l:MySpaces = MakeSpaces(&sw * (v:foldlevel-1))
		let l:line = l:MySpaces."[USER BLOCK ".l:l."]"
	elseif l:line =~ "^\t*\|"
		let l:bodyTextFlag=1
		let l:MySpaces = MakeSpaces(&sw * (v:foldlevel-1))
		let l:line = l:MySpaces."[TABLE]"
	endif
	let l:sub = substitute(l:line,'\t',l:MySpaces,'g')
    let l:sublen = strdisplaywidth(l:sub)
	let l:end = " (" . ((v:foldend + l:bodyTextFlag)- v:foldstart)
	if ((v:foldend + l:bodyTextFlag)- v:foldstart) == 1
		let l:end = l:end . " line)"
	else
		let l:end = l:end . " lines)"
	endif
    let l:endlen = strdisplaywidth(l:end)

    " Multiple cases:
    " (1) Full padding with ellipse (...) or user defined string,
    " (2) No point in padding, pad would just obscure the end of text,
    " (3) Don't pad and use dashes to fill up the space.
    if l:endlen + l:sublen > l:foldlength
        let l:sub = strpart(l:sub, 0, l:foldlength - l:endlen - strdisplaywidth(l:trimstr))
        let l:sub = l:sub . l:trimstr
        let l:sublen = strdisplaywidth(l:sub)
        let l:sub = l:sub . l:end
    elseif l:endlen + l:sublen == l:foldlength
        let l:sub = l:sub . l:end
    else
        let l:sub = l:sub . " " . MakeDashes(l:foldlength - l:endlen - l:sublen - 1) . l:end
    endif
	return l:sub.repeat(' ', winwidth(0)-strdisplaywidth(l:sub))
endfunction
"}}}2
" BodyText(line) {{{2
" Determine the indent level of a line.
function! BodyText(line)
	return (match(getline(a:line),"^\t*:") == 0)
endfunction
"}}}2
" PreformattedBodyText(line) {{{2
" Determine the indent level of a line.
function! PreformattedBodyText(line)
	return (match(getline(a:line),"^\t*;") == 0)
endfunction
"}}}2
" PreformattedUserText(line) {{{2
" Determine the indent level of a line.
function! PreformattedUserText(line)
	return (match(getline(a:line),"^\t*<") == 0)
endfunction
"}}}2
" PreformattedUserTextLabeled(line) {{{2
" Determine the indent level of a line.
function! PreformattedUserTextLabeled(line)
	return (match(getline(a:line),"^\t*<\S") == 0)
endfunction
"}}}2
" PreformattedUserTextSpace(line) {{{2
" Determine the indent level of a line.
function! PreformattedUserTextSpace(line)
	return (match(getline(a:line),"^\t*< ") == 0)
endfunction
"}}}2
" UserText(line) {{{2
" Determine the indent level of a line.
function! UserText(line)
	return (match(getline(a:line),"^\t*>") == 0)
endfunction
"}}}2
" UserTextSpace(line) {{{2
" Determine the indent level of a line.
function! UserTextSpace(line)
	return (match(getline(a:line),"^\t*> ") == 0)
endfunction
"}}}2
" UserTextLabeled(line) {{{2
" Determine the indent level of a line.
function! UserTextLabeled(line)
	return (match(getline(a:line),"^\t*>\S") == 0)
endfunction
"}}}2
" PreformattedTable(line) {{{2
" Determine the indent level of a line.
function! PreformattedTable(line)
	return (match(getline(a:line),"^\t*|") == 0)
endfunction
"}}}2
" MyFoldLevel(Line) {{{2
" Determine the fold level of a line.
function MyFoldLevel(line)
	let l:myindent = Ind(a:line)
	let l:nextindent = Ind(a:line+1)

	if BodyText(a:line)
		if (BodyText(a:line-1) == 0)
			return '>'.(l:myindent+1)
		endif
		if (BodyText(a:line+1) == 0)
			return '<'.(l:myindent+1)
		endif
		return (l:myindent+1)
	elseif PreformattedBodyText(a:line)
		if (PreformattedBodyText(a:line-1) == 0)
			return '>'.(l:myindent+1)
		endif
		if (PreformattedBodyText(a:line+1) == 0)
			return '<'.(l:myindent+1)
		endif
		return (l:myindent+1)
	elseif PreformattedTable(a:line)
		if (PreformattedTable(a:line-1) == 0)
			return '>'.(l:myindent+1)
		endif
		if (PreformattedTable(a:line+1) == 0)
			return '<'.(l:myindent+1)
		endif
		return (l:myindent+1)
	elseif PreformattedUserText(a:line)
		if (PreformattedUserText(a:line-1) == 0)
			return '>'.(l:myindent+1)
		endif
		if (PreformattedUserTextSpace(a:line+1) == 0)
			return '<'.(l:myindent+1)
		endif
		return (l:myindent+1)
	elseif PreformattedUserTextLabeled(a:line)
		if (PreformattedUserTextLabeled(a:line-1) == 0)
			return '>'.(l:myindent+1)
		endif
		if (PreformattedUserText(a:line+1) == 0)
			return '<'.(l:myindent+1)
		endif
		return (l:myindent+1)
	elseif UserText(a:line)
		if (UserText(a:line-1) == 0)
			return '>'.(l:myindent+1)
		endif
		if (UserTextSpace(a:line+1) == 0)
			return '<'.(l:myindent+1)
		endif
		return (l:myindent+1)
	elseif UserTextLabeled(a:line)
		if (UserTextLabeled(a:line-1) == 0)
			return '>'.(l:myindent+1)
		endif
		if (UserText(a:line+1) == 0)
			return '<'.(l:myindent+1)
		endif
		return (l:myindent+1)
	else
		if l:myindent < l:nextindent
			return '>'.(l:myindent+1)
		endif
		if l:myindent > l:nextindent
			"return '<'.(l:nextindent+1)
			return (l:myindent)
			"return '<'.(l:nextindent-1)
		endif
		return l:myindent
	endif
endfunction
"}}}2
"
" This should be a setlocal but that doesn't work when switching to a new .otl file
" within the same buffer. Using :e has demonstrated this.
set foldtext=MyFoldText()

endif " if !exists("loaded_vimoutliner_functions")
" End Vim Outliner Functions
"}}}1
" vim: set foldmethod=marker foldlevel=0:
