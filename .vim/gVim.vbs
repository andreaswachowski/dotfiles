'--- gVim.vbs -----------------------------------------------------------------
'VimTip 118: Configuring gVim as Internet Explorer 'View Source' editor
'
' See HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\View Source Editor\Editor Name
'function: Start gvim, combining multiple arguments to single file argument.
'changes:  20010905: Quoted 'oWShell.Run' filename argument, allowing spaces.
'          20010518: Created.
'author:   Freddy Vulto <fvu@fvu.myweb.nl>

  ' Making variable declaration mandatory
option explicit

dim oWShell, sArg, sFile

  ' Create script object
set oWShell = CreateObject("wscript.shell")
  ' Loop through arguments
for each sArg in wscript.arguments
    ' Add argument to filename
  sFile = sFile & sArg & " "
next
  ' Remove excess space
sFile = Trim(sFile)
  ' Run Vim with file argument.  Additional arguments:
  ' -R: View file readonly
  ' -c "set syntax=html": Use HTML syntax-highlighting (Vim <v6)
  '    NOTE: Use "-c ""set ft=html""" to make it work for Vim v6.
oWShell.Run _
  """D:\Vim\Vim62\gvim.exe """ & _
  "-R """ & sFile & """ " & _
  "-c ""set ft=html"""

  ' Destroy script object
set oWShell = NOTHING


