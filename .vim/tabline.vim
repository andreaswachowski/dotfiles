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
      " Set the title to the current working directory.  Assumes
      " kana/vim-tabbpagecd's setting of t:cwd during TabEnter/TabLeave.
      " In addition, make sure that any directory change is picked up
      " immediately and not just during the TabLeave event:
      if i == t && gettabvar(i, 'cwd') != getcwd()
        call settabvar(i, 'cwd', getcwd())
      endif
      let s .= fnamemodify(gettabvar(i,'cwd'), ':t')
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
