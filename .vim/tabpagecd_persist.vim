function! s:saveTabDirectories()
  if exists('g:SessionLoad')
    return ''
  endif
  let i = 1
  let g:tabpagecd_dirs = []
  while i <= tabpagenr('$')
    call add(g:tabpagecd_dirs, gettabvar(i, 'cwd'))
    let i = i + 1
  endwhile
  let g:Tabpagecd_dirs = join(g:tabpagecd_dirs, ',')
  " if exists('g:this_obsession')
    " let body = readfile(g:this_obsession)
    " call insert(body, 'let g:tabepagecd_dirs = g:tabpagecd_dirs', -3)
    " call writefile(body, g:this_obsession)
    " let g:this_session = g:this_obsession
  " endif
endfunction

function! s:restoreTabDirectories()
  if exists('g:Tabpagecd_dirs')
    let g:tabpagecd_dirs = split(g:Tabpagecd_dirs, ',')
    let i = 1
    while i <= tabpagenr('$')
      call settabvar(i, 'cwd', g:tabpagecd_dirs[i-1])
      let i = i + 1
    endwhile
  endif
endfunction

autocmd BufLeave,VimLeavePre * exe s:saveTabDirectories()
" autocmd VimLeavePre * exe s:saveTabDirectories()
autocmd SessionLoadPost * exe s:restoreTabDirectories()
