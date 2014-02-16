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

