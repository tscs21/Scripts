Set WshShell = WScript.CreateObject("WScript.Shell")

WshShell.Run "%windir%\notepad.exe"
WshShell.AppActivate "Notepad"

WshShell.SendKeys "Hello World!"
WshShell.SendKeys "{ENTER}"
WshShell.SendKeys "abc"
WshShell.SendKeys "{CAPSLOCK}"
WshShell.SendKeys "def"