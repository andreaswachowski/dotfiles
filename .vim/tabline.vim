" See http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
if has('gui')
  set guioptions-=e
endif
if exists("+showtabline")
  " Overwrite is not normally necessary, but helpful when starting vim while inside ~/.vim
  " In that case, the _vimrc would be sourced twice
  function! MyTabLine()
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let s .= '%' . i . 'T'
      let s .= (i == t ? '%1*' : '%2*')
      let s .= ' '
      let s .= i . ':'
      let s .= winnr . '/' . tabpagewinnr(i,'$')
      let s .= ' %*'
      let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
      let bufnr = buflist[winnr - 1]
      let file = bufname(bufnr)
      let buftype = getbufvar(bufnr, 'buftype')
      if buftype == 'nofile'
        if file =~ '\/.'
          let file = substitute(file, '.*\/\ze.', '', '')
        endif
      else
        let file = fnamemodify(file, ':p:t')
      endif
      if file == ''
        let file = '[No Name]'
      endif
      let s .= file
      let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return s
  endfunction
  set stal=1
  set tabline=%!MyTabLine()
" map    <C-Tab>    :tabnext<CR>
" imap   <C-Tab>    <C-O>:tabnext<CR>
" map    <C-S-Tab>  :tabprev<CR>
" imap   <C-S-Tab>  <C-O>:tabprev<CR>
endif
