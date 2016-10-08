; Useful Clipboard hokey additions
; 8 March 2004 - CyberSlug


; Append, Ctrl+Shift+C, adds newline plus selected text to clipboard.
^+c::
   bak = %clipboard%
   Send, ^c
   clipboard = %bak%`r`n%clipboard%
return


; Replace, Ctrl+Shift+V, swaps selected text with clipboard text.
^+v::
   itemOne = %clipboard%
   Send, ^c
   itemTwo = %clipboard%
   clipboard = %itemOne%
   Send, ^v
   clipboard = %itemTwo%
return


; Clear, Ctrl+Shift+X, clear the clipboard
^+x::
   clipboard = ;null
return