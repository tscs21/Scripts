;Clipboard History, By ManaUser

;Command          Key                   Alternate (commented out)
;Older            Win + Up              Win + A
;Newer            Win + Down            Win + Z
;Delete Current   Win + Delete          Win + X
;Clear History    Win + Shift + Delete  Win + Shift + X
;Empty Clipboard  Win + Ctrl  + Delete  Win + Ctrl  + X

MAX_CLIPS = 10
TIP_DELAY = 2

#SingleInstance Force
#NoEnv

LastClip = 0
Menu TRAY, Icon, Shell32.dll, 22, 1
SetTimer WatchWait, -1000
Return

;#a::
#Up::
   If (LastClip = 0)
      Return
   CurClip--
   If (CurClip < 1)
      CurClip := LastClip
   Temp := SavedShortClip%CurClip%
   ToolTip %Temp%
   SetTimer KillToolTip, % TIP_DELAY * -1000
   Watch := 0
   Clipboard := SavedClip%CurClip%
   SetTimer WatchWait, -1000
Return

;#z::
#Down::
   If (LastClip = 0)
      Return
   CurClip++
   If (CurClip > LastClip)
      CurClip := 1
   Temp := SavedShortClip%CurClip%
   ToolTip %Temp%
   SetTimer KillToolTip, % TIP_DELAY * -1000
   Watch := 0
   Clipboard := SavedClip%CurClip%
   SetTimer WatchWait, -1000
Return

;#x::
#Delete::
   If (LastClip = 0)
      Return
   SavedClip%CurClip% =
   SavedShortClip%CurClip% =
   Temp =
   Collapse(CurClip)
   ToolTip History Item Deleted.
   SetTimer KillToolTip, % TIP_DELAY * -1000
Return

;#+x::
#+Delete::
Loop %MAX_CLIPS%
{
   SavedClip%A_Index% =
   SavedShortClip%A_Index% =
}
LastClip := 0
NewClip := 0
CurClip := 0
ToolTip Clipboard History Cleared.
SetTimer KillToolTip, % TIP_DELAY * -1000
Return

OnClipboardChange:
If (Watch = 0 OR A_EventInfo = 0 )
{
   Watch := 0                 ; For improved compatibility with
   SetTimer WatchWait, -1000  ; other AutoHotkey scripts that
   Return                     ; access the clipboard.
}
If (A_EventInfo = 1) ;Text
{
   NewClip++
   If ( NewClip > MAX_CLIPS)
      NewClip := 1
   If ( NewClip > LastClip)
      LastClip := NewClip
   CurClip := NewClip
   SavedClip%NewClip% := ClipboardAll
   Temp := Clipboard
   Temp := RegExReplace(Temp, "^\s*|\s*$", "")
   If (StrLen(Temp) > 100 OR InStr(Temp, "`n") )
      Temp := RegExReplace(Temp, "`as)^([^`r`n]{1,50}).*?([^`r`n]{1,50})$", "$1...`n...$2")
   SavedShortClip%NewClip% := Temp
   Loop %LastClip%
   Temp =
}
Return

;#^x::
#^Delete::
Clipboard =
ToolTip Clipboard Cleared.
SetTimer KillToolTip, % TIP_DELAY * -1000
Return


Collapse(Position)
{
   Global
   If (CurClip > Position)
      CurClip--
   Loop ;While Position < LastClip
   {
      Temp := Position + 1
      SavedClip%Position% :=SavedClip%Temp%
      SavedShortClip%Position% :=SavedShortClip%Temp%
      Position++
      If (Position >= LastClip)
         Break
   }   
   SavedClip%LastClip% =
   SavedShortClip%LastClip% =
   LastClip--
   If (NewClip > LastClip)
      NewClip := LastClip
}

KillToolTip:
Tooltip
Return

WatchWait:
Watch := 1
return

#Space::
Menu, ClipbrdHist, Add
Menu, ClipbrdHist, DeleteAll
Loop %LastClip%
{
  Menu, ClipbrdHist, Add, % ((A_Index = CurClip) ? "*" : "") A_Index . ": " . SavedShortClip%A_Index%, ChangeClip
}
Menu, ClipbrdHist, show
return

ChangeClip:
CurClip := A_ThisMenuItemPos
Watch := 0
Clipboard := SavedClip%CurClip%
SetTimer WatchWait, -1000
return
