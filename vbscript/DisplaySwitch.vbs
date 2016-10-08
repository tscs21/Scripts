WScript.CreateObject("WScript.Shell").Run "%windir%\System32\DisplaySwitch.exe"
WScript.Sleep 500
WScript.CreateObject("WScript.Shell").SendKeys "{DOWN}"
WScript.CreateObject("WScript.Shell").SendKeys "{DOWN}"
WScript.CreateObject("WScript.Shell").SendKeys "{ENTER}"