if has('conceal') && g:vim_json_syntax_conceal == 1
  :syntax match GlogPrefix /\vfugitive:.*\.git\/\// conceal
  :syntax region GlogGitHash oneline start="."ms=e+8 end="|" conceal
  :syntax match Timezone /\v\+\d{-4} / conceal
  :set conceallevel=2
  :set concealcursor=nvic
endif
