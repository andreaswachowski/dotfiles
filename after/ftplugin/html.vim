" ===================================================================
" HTML - HTML - HTML - HTML - HTML - HTML - HTML - HTML
" ===================================================================
"
" File:      $HOME/vim/src/html.vim
" This file: <URL:http://www.math.fu-berlin.de/~guckes/vim/src/html.vim>
" Purpose:      Setup file for the editor Vim for Webpage/HTML editing
" Author:       Sven Guckes guckes@vim.org (guckes@math.fu-berlin.de)
"               <URL:http://www.math.fu-berlin.de/~guckes/>
" Comments:     See also:  <URL:http://www.vim.org/howto/html.html>
"               Please send comments to me - email preferred!
" See also:     http://www.math.fu-berlin.de/~guckes/www/html.html
"               HTML Mini Guide
" Last update:  Mon Dec 24 08:45:00 MET 2001
"
" HTML = HyperText Markup Language - the language of the World Wide Web
" XHTML - new standard.  this enforces that all tags *must* be "closed",
" ie when you use a tag then there must also be a "closing tag".
" 011022: changed tags in XHTML style, ie with closing tags.
"
" ===================================================================
" HTML - useful abbreviations
" ===================================================================
"
"     YWWW  The start of a typical Web address:
  iab YWWW  http://www.
  iab Yhtt  http://
"
" ===================================================================
" HTML - working on files
" ===================================================================
"
"  Whenever I edit a web page I use ",e" to start the edit command.
"  And I use ",rn" to read in a web page template:
"       ,e  = edit www file
" The Webpages are on the web server which is mounted on /import/Mweb
  nmap  ,e :e /import/Mweb/guckes/
" nmap  ,e :e ~/.P/
" The directory ~/.P is a link to the directory with my webpages.
" the name is short so it will be short for the output of ":ls".
"
"   I used ",e" for the command here before, but this was part of the
"   default string for "highlight", so while entering the default
"   string the ",e" it got expanded.  Darn!
"
"       ,rm = read mailto (standard html file for a mailto link to my address)
" map   ,rm :r ~/.P/txt/mailto.html
"
"       ,rn = read new-page (standard html file for a new web page)
"       see http://www.math.fu-berlin.de/~guckes/txt/New.page.form.html
  map   ,rn :0r ~/.P/txt/New.page.form.html
"
"       ,mp = "make public"  - set permissions of file to "rw-r--r--"
  nmap  ,mp :!chmod 644 %<CR>
"       ,MP = "make private" - set permissions of file to "rw-------"
  nmap  ,MP :!chmod 600 %<CR>
"
" ===================================================================
"      wb - white body
"      include a body tage with white background
  iab Ywb  <body bgcolor="#ffffff">
" ===================================================================
"
" ===================================================================
" HTML - Inserting "single" tags
" ===================================================================
"
" 011022: These tags a re now in XHTML style!
"
" iab Ybr <br>
  iab Ybr <br />
" iab Yhr <hr>
  iab Yhr <hr />
" iab Yp  <p>
" iab Yp  <p><p /><c-o><
  iab Yp  <p><cr></p><up>
"
" ===================================================================
" HTML - making environments
" ===================================================================
"
" HTML ,me = "make environment"
" make current word an HTML environment
 nmap ,me viwyi<<ESC>ea></<C-R>"><ESC>
 vmap ,me    yi<<ESC>ea></<C-R>"><ESC>
"
" Example:  "foo" -> "<foo></foo>"
"
" ===================================================================
" HTML - inserting environments
" ===================================================================
"
" Comment:
  iab  Ycom  <!--X--><ESC>FXs
" vmap ,com <esc>`<i<!--<ESC>`>i--><ESC>
" always comment *whole* lines blocks):
  vmap ,com <esc>`<O<!--<ESC>`>o--><ESC>
"
" Make paragraph
  vmap ,P   <esc>`<O<p><ESC>`>o</p><ESC>
"
" ===================================================================
" HTML - changing the appearance/font of text
" ===================================================================
"
" BlockQuoted Text:
  iab  Ybl  <blockquote></blockquote><ESC>T>i
" vmap ,bl  "zdi<blockquote><C-R>z</blockquote><ESC>2F>
"
" Bold text:
  iab  Yb   <b></b><ESC>T>i
" vmap ,b   "zda<b><C-R>z</b><ESC>F>
  vmap ,b   "zdi<b><C-R>z</b><ESC>F>
"
" Center Inline Text:
  iab  Ycenter <center></center><ESC>T>i
  iab  Ycen    <center></center><ESC>T>i
  vmap ,cen "zdi<center><C-M><C-R>z<C-M></center><ESC>?><CR>
"
" Center Text Blocks:
  iab  YCen <center><CR></center><ESC>O
  vmap ,Cen <ESC>'<O<center><ESC>'>o</center><ESC>
"
" Code in Text:
  iab  Ycod <code></code><ESC>T>i
  vmap ,cod "zdi<code><C-M><C-R>z<C-M></code><C-M><ESC>T>i
"
" Italic Text:
  iab  Yi   <i></i><ESC>T>i
  vmap ,i   "zdi<i><C-R>z</i><ESC>T>
"
" Typewriter Type:
  iab  Ytt   <tt></tt><ESC>T>i
  vmap ,tt   "zdi<tt><C-R>z</tt><ESC>T>
"
" ===================================================================
" HTML - Preserving Text Structure
" ===================================================================
"
" Preserve Text Formatting *with*  interpretation of HTML:
  iab  Ypre <pre></pre><ESC>T>i
" vmap ,pre "zdi<pre><C-M><C-R>z</pre><C-M><ESC>T>
  vmap ,pre mz:<ESC>'<O<pre><ESC>'>o</pre><ESC>`z
"
" Preserve Text Formatting without interpretation of HTML:
"           Insert environment <xmp></xmp>
  iab  Yxmp <xmp></xmp><ESC>T>i
" vmap ,xmp "zdi<xmp><C-M><C-R>z<C-M></xmp><C-M><ESC>T>i
  vmap ,xmp mz:<ESC>'<O<xmp><ESC>'>o</xmp><ESC>`z
"
" ===================================================================
" HTML - Making Tables
" ===================================================================
"
" Table Environment
  iab  Ytable <table><cr></table><up>
" Table Data
  iab  Ytd  <td></td><ESC>T>i
" iab  Ytd  <td><cr></td><up>
  vmap ,td  "zdi<td><C-R>z</td><ESC>T>
" Table Row
" iab  Ytr  <tr></tr><ESC>T>i
  iab  Ytr  <tr><cr></tr><up>
  vmap ,tr  "zdi<tr><C-R>z</tr><ESC>T>i
"
"
" ===================================================================
" HTML - Making Header Lines (h1 to h6)
" ===================================================================
"
  iab  Yh1 <h1></h1><ESC>T>i
  vmap ,h1 "zdi<h1><C-R>z</h1><ESC>2F>
  iab  Yh2 <h2></h2><ESC>T>i
  vmap ,h2 "zdi<h2><C-R>z</h2><ESC>2F>
  iab  Yh3 <h3></h3><ESC>T>i
  vmap ,h3 "zdi<h3><C-R>z</h3><ESC>2F>
  iab  Yh4 <h4></h4><ESC>T>i
  vmap ,h4 "zdi<h4><C-R>z</h4><ESC>2F>
  iab  Yh5 <h5></h5><ESC>T>i
  vmap ,h5 "zdi<h5><C-R>z</h5><ESC>2F>
  iab  Yh6 <h6></h6><ESC>T>i
  vmap ,h6 "zdi<h6><C-R>z</h6><ESC>2F>
"
" ===================================================================
" HTML - Making Lists and List Items
" ===================================================================
"
"           Insert "ordered list" with one list element
  iab Yol <ol><CR><li><CR></ol><ESC>k
"           Insert "unordered list" with one list element
  iab Yul <ul><CR><li><CR></ul><ESC>k
"           Insert "decsription list" with one list element
" iab Ydl <dl><CR><dt><CR><dd><CR><p><CR></dl><CR><ESC>4kA
  iab Ydl <dl><CR><CR><dt><CR><dd><CR><p><CR><CR></dl><CR><ESC>5kA
"
" Insert "list" item (for both ordered and unordered list)
  iab Yli <li>
" Insert "description list" item
  iab Ydt <dt><CR><dd><CR><p><CR><ESC>kA
  iab Ydp <dt><CR><dd><C-M><p><C-M><ESC>kkkA
"
" ===================================================================
" HTML - Making Links
" ===================================================================
"
"
"     A HREF (HTML 2.0)
" insert "generic link"
  iab  Yhref <a href=""></a><ESC>?""<CR>a
  vmap ,href "zdi<a href=""><C-R>z</a><ESC>F"i
  vmap ,HREF "zdi<a href="<C-R>z"></a><ESC>F"i
"
" make current URL a link:
  vmap ,link "zdi<a href="<C-R>z"<C-M><C-I>><C-R>z</a><ESC>F"i
"
" add link to current text:
  vmap ,text "zdi<a href=""><C-R>z</a><ESC>F"i
"
"     A NAME (HTML-2.0)
  iab  Yname <a name=""></a><ESC>?""<CR>a
  vmap ,name "zdi<a name="<C-R>z"<C-M><C-I>><C-R>z</a><ESC>2F>
"
"            Insert/make link to image
  iab  Yimg  <img alt="[]"<C-M>   align=<C-M>     src=""></a><ESC>?""<CR>a
"
" 000811
"            Insert a link to an image with a thumbnail
  iab YIMG   <a  href="PIC"><cr><img alt=""<cr>   align=right<cr>     src=""><cr></a><cr>
"
"            Insert/make mailto link
  iab  Ymail <a href="mailto:"></a><ESC>?:<CR>a
  vmap ,mail "zdi<a href="mailto:<C-R>z"<C-M><C-I><C-I>><C-R>z</a><ESC>2F>
  vmap ,Mail "zdi<a href="mailto:<C-R>z"><C-R>z</a><ESC>2F>
"
"            Insert/make link to newsgroup
  iab  Ynews <a href="news:"></a><ESC>?:<CR>a
  vmap ,news "zdi<a href="news:<C-R>z"><C-R>z</a><ESC>2F>
"
" ===================================================================
"      Ypage: Insert page description with a possible link and text
  iab  Ypage   <C-M>page:<C-I><C-M>link:<C-I><C-M>text:<C-I><ESC>kkA
"
" Example:
" page:	http://www.math.fu-berlin.de/~guckes/
" link:	http://www.math.fu-berlin.de/~guckes/sven/
" text:	the link to Sven's personal homepage
"
" I use this when reporting error to links.
" This is usually a lot faster than "describing" a link. ;-)
"
" ===================================================================
" For adding descriptions and keywords to important pages:
" <META Name="description" Content="Write your description here">
" <META Name="keywords"    Content="Write your keywords here">
"
" ===================================================================
" Colorizing Text
" ===================================================================
"
"      ,Cblu = colorize the selection with color "blue"
" vmap ,Cblu "zdi<font color="#0000FF"><C-R>z</font>
  vmap ,cblu "zdi<font color="blue"><C-R>z</font><esc>
"      ,Cgre = colorize the selection with color "green"
  vmap ,cgre "zdi<font color="green"><C-R>z</font><esc>
"      ,Cmag = colorize the selection with color "magenta"
  vmap ,cmag "zdi<font color="magenta"><C-R>z</font><esc>
"      ,Cred = colorize the selection with color "red"
  vmap ,cred "zdi<font color="red"><C-R>z</font><esc>
"      ,Cwhi = colorize the selection with color "white"
  vmap ,cwhi "zdi<font color="white"><C-R>z</font><esc>
"      ,Cyel = colorize the selection with color "yellow"
  vmap ,cyel "zdi<font color="yellow"><C-R>z</font><esc>
"
" ===================================================================
" HTML - handling special text
" ===================================================================
"
" HTML - inserting special characters
  imap ;& &amp;
  imap ;K &copy;
  imap ;" &quot;
  imap ;< &lt;
  imap ;> &gt;
"
" ===================================================================
" HTML - inserting umlauts in HTML  [981110]
  imap \Ae &Auml;
  imap \Oe &Ouml;
  imap \Ue &Uuml;
  imap \ae &auml;
  imap \oe &ouml;
  imap \ue &uuml;
  imap \ss &szlig;
"
" ===================================================================
" HTML - Converting diphtongs to umlauts (ISO-8859-1) [960430]
" cnoremap ,ae %s/ae/<C-V>228/gc
" cnoremap ,oe %s/oe/<C-V>246/gc
" cnoremap ,ue %s/ue/<C-V>252/gc
" cnoremap ,Ae %s/Ae/<C-V>196/gc
" cnoremap ,Oe %s/Oe/<C-V>124/gc
" cnoremap ,Ue %s/Ue/<C-V>220/gc
" cnoremap ,ss %s/ss/<C-V>223/gc
"
" ===================================================================
" HTML - Converting diphtongs to HTML umlauts [011023]
" cnoremap ,ae %s/ae/\&auml;/gc
" cnoremap ,oe %s/oe/\&ouml;/gc
" cnoremap ,ue %s/ue/\&uuml;/gc
" cnoremap ,Ae %s/Ae/\&Auml;/gc
" cnoremap ,Oe %s/Oe/\&Ouml;/gc
" cnoremap ,Ue %s/Ue/\&Uuml;/gc
" cnoremap ,ss %s/ss/\&szlig;/gc
"
" ===================================================================
"       ,= = turn "===" into headline of size 1
  nmap  ,= :%s/^===\(.*\)$/<h1>\1<\/h1>/c<CR>
" Example:
" before:  === New section
" after:   <h1>New section</h1>
"
" ===================================================================
" HTML 3.0
" ===================================================================
" environments:
" ABBREV ACRONYM AU BANNER BIG BQ CAPTION CREDIT DEL DFN DIR DIV FN
" HTML INS NOTE OL P Q S SMALL SUB SUP TAB V
" other:
" FIG LANG OVERLAY RANGE SPOT STYLE
"
" ===================================================================
" HTML - Misc
" ===================================================================
"
" HTML - Add closing tags to name tag
" (which I forgot when I started HTML):
" map ,,,, :g/^<a name="[a-z_]*">$/s/$/<\/a>/
" Example:
" before:  <a name="close_tag">
" after:   <a name="close_tag"></a>
"
" Insert/make reference link to overview list (short"cut")
  iab  Ycut  \| <a href="#"<C-I>></a><ESC>F#a
" Vim-6 complains about trailing characters here.. huh?
"
  vmap ,cut  "zdi<a href="#<C-R>z"<C-I>><C-R>z</a><ESC>2F>
"
"
" ===================================================================
" PHP stuff
" ===================================================================
  iab phpinc  <?php include ('X'); ?><esc>FXs
  iab phpfoot <?php include ('http://www.math.fu-berlin.de/~guckes/footer.php'); ?>
  iab phptime <?php echo Date("D M d H:i:s",filemtime($SCRIPT_FILENAME)); ?>
" ===================================================================
" Automatic insertion of last update (vim 5 and higher)
" ===================================================================
if version>500
	iab YDATE <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
	" Example: Tue Dec 16 12:07:00 CET 1997

	"     ,L  = "Last updated" - replace old time stamp with a new one
	"        preserving whitespace and using internal "strftime" command:
	"       requires the abbreviation  "YDATE"
	  map ,L 1G/Last update:\s*/e+1<CR>CYDATE<ESC>
	" Example:
	" before:  "Last update:   Thu Apr  6 12:07:00 CET 1967"
	" after:   "Last update:   Tue Dec 16 12:07:00 CET 1997"
endif

set ts=2
set sw=2
set expandtab
" end of file vim: tw=999
