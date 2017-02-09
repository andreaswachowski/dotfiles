" Locomotive Basic Syntax Highlighting

syn case ignore
set isk=a-z,A-Z,48-57,$,',.,_

syn keyword locBasInst ABS AFTER AND ASC ATN AUTO BIN$ BORDER BREAK CALL CAT
syn keyword locBasInst CHAIN CHR$ CINT CLEAR CLG CLOSEIN CLOSEOUT CLS CONT
syn keyword locBasInst COPYCHR$ COS CREAL CURSOR DATA DEC$ DEF DEFINT DEFREAL
syn keyword locBasInst DEFSTR DEG DELETE DERR DI DIM DRAW DRAWR EDIT EI ELSE
syn keyword locBasInst END ENT ENV EOF ERASE ERL ERR ERROR EVERY EXP FILL FIX
syn keyword locBasInst FN FOR FRAME FRE GOSUB GOTO GRAPHICS HEX$ HIMEM IF INK
syn keyword locBasInst INKEY INKEY$ INP INPUT INSTR INT JOY KEY LEFT$ LEN LET
syn keyword locBasInst LINE LIST LOAD LOCATE LOG LOG10 LOWER$ MASK MAX MEMORY
syn keyword locBasInst MERGE MID$ MIN MODE MOVE MOVER NEW NEXT NOT ON OPENIN
syn keyword locBasInst OPENOUT OR ORIGIN OUT PAPER PEEK PEN PI PLOT PLOTR POKE
syn keyword locBasInst POS PRINT RAD RANDOMIZE READ RELEASE REMAIN RENUM
syn keyword locBasInst RESTORE RESUME RETURN RIGHT$ RND ROUND RUN SAVE SGN SIN
syn keyword locBasInst SOUND SPACE SPACE$ SPC SPEED SQ SQR STOP STR$ STRING$ SWAP
syn keyword locBasInst SYMBOL TAB TAG TAGOFF TAN TEST TESTR THEN TIME TROFF TRON
syn keyword locBasInst UNT UPPER$ USING VAL VPOS WAIT WEND WHILE WIDTH WINDOW
syn keyword locBasInst WRITE XOR XPOS YPOS ZONE

" Strings
syn region locBasString start=/"/ skip=/\\"/ end=/"/ oneline
syn region locBasString start=/'/ end=/'/ oneline

" Operators
syn match locBasOther "[~+\-*/%^&=!<>]"

" Numbers
syn match locBasNumber "\<\$\>"
syn match locBasNumber "\<[01]\+b\>"
syn match locBasNumber "\<\d\x*h\>"
syn match locBasNumber "\<\d\+\>"
syn match locBasNumber "\<%[01]\+\>"
syn match locBasNumber "\$[0-9a-fA-F]\+"
syn match locBasNumber "\<&[01]\+\>"
syn match locBasNumber "\<0x[0-9a-fA-F]\+\>"

" Comments
syn match locBasComment "REM.*$" contains=cTodo
syn match locBasComment2 "'.*$" contains=cTodo
" syn match locBasComment "^\*$"
" syn region locBasComment2 start="\<\.endasm\>" skip="\n" end="\<\.asm\>" keepend contains=z80Comment,z80Comment2
" syn region locBasComment start="\/\*" end="\*\/" contains=cTodo

command -nargs=+ HiLink hi def link <args>

HiLink locBasComment Comment
HiLink locBasComment2 Comment
HiLink locBasInst Statement
HiLink locBasNumber Number
HiLink locBasString String
HiLink locBasOther Operator

delcommand HiLink

let b:current_syntax = "locbas"
