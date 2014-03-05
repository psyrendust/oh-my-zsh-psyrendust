'#
'# Restarts the current Cygwin shell
'#
'# Authors:
'#   Larry Gordon
'#

Set WinScriptHost = CreateObject("WScript.Shell")
' Send {Ctrl + Shift + R} which is keymapped to "Recreate active console"
WinScriptHost.SendKeys "^+r"
' Wait for the "Restart current console dialog"
WScript.Sleep 200
' Send {Alt + s} to select the "Restart" button
WinScriptHost.SendKeys "%s"
Set WinScriptHost = Nothing
