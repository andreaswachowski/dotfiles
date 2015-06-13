set showmatch
set tabstop=2
set shiftwidth=2
set expandtab

" Simpler input for accolades on a German keyboard
imap ö {
imap ä }

" Abbreviations and mappings for general commands
imap __pr System.out.println();hi
" Abbreviations and mappings for Junit:
" new test method
imap __tstm public void test() {}kf(i
imap __exc try {} catch ( RpmsMsgException e ) {System.out.println( "Exception: " + e );e.printStackTrace();}4ko

" Getters, setters (see vimtips.txt Tip 288):
"map jgs mawv/ <Enter>"ty/ <Enter>wvwh"ny/getters<Enter>$a<Enter><Enter>public <Esc>"tpa<Esc>"npbiget<Esc>l~ea()<Enter>{<Enter><Tab>return <Esc>"npa;<Enter>}<Esc>=<Enter><Esc>/setters<Enter>$a<Enter><Enter>public void <Esc>"npbiset<Esc>l~ea(<Esc>"tpa <Esc>"npa)<Enter>{<Enter><Tab>this.<Esc>"npa=<Esc>"npa;<Enter>}<Esc>=<Enter>`ak

" Automatically remove trailing spaces before writing the file
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
autocmd BufWritePre *.c :%s/\s\+$//e
