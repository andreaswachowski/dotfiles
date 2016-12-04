if exists("g:loaded_enhanced_diff")
  EnhancedDiff patience

  if &diff
    let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
  endif
endif
