if exists('g:loaded_fugitive')
	set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
	" Overriding a few VCSCommands with fugitive equivalents
	nmap \cs :Gstatus
	nmap \cc :Gcommit
	nmap \cv :Gdiff
	nmap \cl :Glog
	nmap \cb :Gblame
endif
