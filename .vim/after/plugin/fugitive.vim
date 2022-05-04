if exists('g:loaded_fugitive')
  set statusline=%-f\ %h%m%r%<%{fugitive#statusline()}%=%14.(%l,%c%V%)\ %P
  " Overriding a few VCSCommands with fugitive equivalents
  nmap \cs :Git
  nmap \cc :Git commit
  nmap \cv :Gdiff
  nmap \cl :Gclog
  nmap \cb :Git blame
endif
