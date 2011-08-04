if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	au! BufNewFile,BufRead *.ly,*.ily   setf lilypond
	" filetype for Supermemo Databases:
	au BufRead,BufNewFile *.smd		setfiletype smd
augroup END
