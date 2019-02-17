if exists('g:loaded_fugitive')
if exists('g:loaded_fugitive_qf_syntax')
  finish
endif
let g:loaded_fugitive_qf_syntax = 1

function! FugitiveQuickFixSyntax()
  " syn match	qfFileName	"^[^|]*" nextgroup=qfSeparator
  if has('conceal')
    " :syntax match glogPrefix /\vfugitive:.*\.git\/\// conceal
    " :syntax region glogGitHash oneline start="."ms=e+8 nextgroup=qfSeparator conceal
    " :syntax match glogTimeZone /\v\+\d{-4} / conceal
    " ":hi def link glogGitHash	Directory
    :set conceallevel=2
    :set concealcursor=nvic
  endif
endfunction

augroup FugitiveQuickFix
  au!
  au FileType qf call FugitiveQuickFixSyntax()
augroup END
endif
