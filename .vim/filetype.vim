if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	au! BufNewFile,BufRead *.ly,*.ily   setf lilypond
	" filetype for Supermemo Databases:
	au BufRead,BufNewFile *.smd		setfiletype smd
augroup END

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.mbdb let &bin=1
  au BufReadPost *.mbdb if &bin | %!xxd
  au BufReadPost *.mbdb set ft=xxd | endif
  au BufWritePre *.mbdb if &bin | %!xxd -r
  au BufWritePre *.mbdb endif
  au BufWritePost *.mbdb if &bin | %!xxd
  au BufWritePost *.mbdb set nomod | endif
augroup END

" Add hyphen and underscore for web development keywords
" http://stackoverflow.com/questions/7559737/vim-how-to-autocomplete-in-a-css-file-with-tag-ids-and-class-names-declared-in#7560484
au FileType css,scss,html,slim setlocal iskeyword=@,48-57,_,-,?,!,192-255

augroup markdown
  au!
  au BufNewFile,BufReadPost *.md,*.markdown setlocal filetype=markdown
augroup END

" For Transcribe!
au BufEnter *.xsc setlocal tw=0

" Do not (!) load delimitMate for html and xml files.
au FileType html let b:loaded_delimitMate = 1
au FileType xml let b:loaded_delimitMate = 1

au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* setfiletype nginx

au BufEnter *.jsx setlocal expandtab
