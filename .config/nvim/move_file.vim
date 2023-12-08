" -------------------------------------------------------------------------
" MoveFiles, see http://stackoverflow.com/questions/10884520/move-file-within-vim
function! MoveFile(newspec)
     let old = expand('%')
     " could be improved:
     if (old == a:newspec)
         return 0
     endif
     exe 'sav' fnameescape(a:newspec)
     call delete(old)
     " TODO: Delete old buffer
endfunction

command! -nargs=1 -complete=file -bar MoveFile call MoveFile('<args>')
