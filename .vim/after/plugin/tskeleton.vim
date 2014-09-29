" Filetype skeletons
" The test is explicit just in case the plugin is not installed.
" (because this file, "after/plugin/tskeleton.vim", will be loaded
" whether or not a plugin of the same name has been loaded)
if exists("loaded_tskeleton")
  au BufNewFile anki.txt TSkeletonSetup ankitemplate.txt
  au BufNewFile anki.tex TSkeletonSetup ankitemplate.tex

  " Normally mapped to <c-j>, but that would override my _vimrc
  " settings for movement between split windows:
  let g:tskelMapGoToNextTag = '<c-n>'
endif
