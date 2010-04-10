" Vim settings file
" Language:	ROS log file
" Version:	0.1
" Last Change:	2006 February 2
" URL:		
" Maintainer:	Andreas Wachowski
" Usage:	Do :help roslog-plugin from Vim

" Only do these settings when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't do other file type settings for this buffer
let b:did_ftplugin = 1

" mop = MtObjectPrinter
:syn region enterLeave start="ENTER" end="LEAVE" transparent fold
:syn region mopTopLevelAttached start="^Attached Object" end="\nAttached"me=e-10 contained transparent fold
:syn region mopTopLevelRecord start="^Record in Buffer" start="^Record at Index" end="\nRecord at Index"me=e-20 end="^$" contains=mopTopLevelAttached contained keepend transparent fold
:syn region iefBuffer start="IEF buffer before calling" end="APPLICATION MESSAGE" contained transparent fold
:syn region mtObjectPrinterOutput start="^\d\d:\d\d.*(4000), number of records" end="^\d\d:\d\d"me=e-10 contains=mopTopLevelRecord,iefBuffer keepend transparent fold
:syn sync fromstart
:set foldmethod=syntax
