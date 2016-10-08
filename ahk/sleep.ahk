#NoEnv
#NoTrayIcon
#SingleInstance force
SendMode Input

^!+s::
WinGet, Window,,A
Send {Volume_Mute}
SendMessage, 0x112, 0xF170, 2,, Program Manager
DllCall("LockWorkStation")
WinWaitNotActive,ahk_id %Window%
WinWaitActive,ahk_id %Window%
Send {Volume_Mute}
ExitApp