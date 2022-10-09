#SingleInstance force

^?::
IfWinnotExist, ahk_exe pulseaudio.exe
{
    run pulseaudio.lnk ,, hide, kee
}
Else
{
msgbox, exist
}
WinKill, % "ahk_pid " wee
run kex.bat,, hide, wee
return
^/::
Winshow, ahk_class vncviewer
WinActivate, ahk_class vncviewer
return
^.::
Winminimize, ahk_class vncviewer
Winhide, ahk_class vncviewer
return

RAlt::
monkey = 1
return

RAlt Up::
monkey = 0 
return

#if monkey = 1
k::down
l::right
i::up
j::left
