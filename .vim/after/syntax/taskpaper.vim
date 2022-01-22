syn clear taskpaperListItem
syn match taskpaperListItem1	/^\t-\s\+.*/ contains=taskpaperContext
syn match taskpaperListItem2	/^\t\t-\s\+.*/ contains=taskpaperContext

syn clear taskpaperProject
syn match taskpaperProject1	/^[^\t].\+:\(\s\+@[^ \t(]\+\(([^)]*)\)\?\)*$/ contains=taskpaperContext
syn match taskpaperProject2	/^\t.\+:\(\s\+@[^ \t(]\+\(([^)]*)\)\?\)*$/ contains=taskpaperContext

hi link taskPaperProject1 GruvboxRed
hi link taskPaperProject2 GruvboxOrange
hi link taskPaperListItem GruvboxFg1
hi link taskPaperListItem1 GruvboxFg1
hi link taskPaperListItem2 GruvboxAqua
hi link taskPaperContext GruvboxBlue
hi link taskPaperComment GruvboxFg4
