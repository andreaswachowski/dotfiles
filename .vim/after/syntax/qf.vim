if !has('conceal')
  finish
endif

syntax match glogPrefix "^fugitive:.*\.git//" conceal nextgroup=GlogGitHash
syntax match glogGitHash /......../ nextgroup=GlogGitHashEnd contained
syntax match glogGitHashEnd "[^|]*" conceal contained
syntax match glogSeparator "|" conceal
syntax match glogAuthor /[^\|]*/ conceal contained
syntax match timeStampDate "\d\d\d\d-\d\d-\d\d"
syntax match timeStampHourMinutes "\d\d:\d\d"
syntax match timeStampSeconds ":\d\d "me=e-1 conceal
syntax match timeStampTimeZone /\v\+\d{-4} / conceal
hi def link glogGitHash Directory
hi def link timeStampDate Directory
hi def link timeStampHourMinutes Directory
