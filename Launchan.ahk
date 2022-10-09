#NoEnv
SetKeyDelay, 0, 50
#SingleInstance force
#NoEnv
SetWorkingDir %A_ScriptDir%
#Persistent
#InputLevel 22 
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#installKeybdHook
#UseHook On
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 10
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
DetectHiddenWindows, On
SetTitleMatchMode,2
FileCreateDir, % A_workingdir "\ahk's"


CloseScript(Name)
	{
	DetectHiddenWindows On
	SetTitleMatchMode RegEx
	IfWinExist, i)%Name%.* ahk_class AutoHotkey
		{
		WinClose
		WinWaitClose, i)%Name%.* ahk_class AutoHotkey, , 2
		If ErrorLevel
			return "Unable to close " . Name
		else
			return "Closed " . Name
		}
	else
		return Name . " not found"
	}

number = 0


dict := {}


Gui Destroy
    Gui, -Caption 
    Gui, Color, c202020
    Gui, +ToolWindow
    Gui, Font, cffffff
    Gui, Font, S10
	Gui, +AlwaysOnTop +Owner


Gui, Add, text,,{ E-edit  D-delete  N-new  I-Dir }
Loop, %A_workingdir%\ahk's\*.ahk
{
number++


If WinExist( A_loopfilename . " ahk_class AutoHotkey"){
    Gui, Font, c34eb98
Gui, Add, text,, % number "  " A_loopfilename  
    Gui, Font, cffffff
}
else
{
    Gui, Font, cffffff
Gui, Add, text,, % number "  " A_loopfilename  
}

}



Gui, font, c000000
Gui, Add, Edit ,w200 vhoyy
Gui, Show, NoActivate xCenter yCenter  NA
guicontrol, focus, hoyy


+i::
Gui,  Destroy
run, % A_workingdir "\ahk's"
exitapp

+n::
GuiControlGet, hoyy
Gui,  Destroy
run, % "cmd.exe /c vim " A_workingdir "\ahk's\" hoyy ".ahk" 
exitapp

+e::
GuiControlGet, hoyy
number = 0
Gui,  Destroy
Loop, %A_workingdir%\ahk's\*.ahk
{
number++

    if (number = hoyy){
        run, % "cmd.exe /c vim " A_loopfiledir "\" A_loopfilename
        exitapp
    }
}
exitapp


enter::
GuiControlGet, hoyy
number = 0
Gui,  Destroy
Loop, %A_workingdir%\ahk's\*.ahk
{
number++

if (number = hoyy){
    If WinExist( A_loopfilename . " ahk_class AutoHotkey"){

        closescript(a_loopfilename)
        exitapp

    }
    else
    {
        run, % A_loopfiledir "\" A_loopfilename
        exitapp

    }

}
}
exitapp


+d::
GuiControlGet, hoyy
number = 0
Gui,  Destroy
Loop, %A_workingdir%\ahk's\*.ahk
{
number++

    if (number = hoyy){
        filedelete, % A_loopfiledir "\" A_loopfilename
        exitapp
    }
}
exitapp


esc::  ; Indicate that the script should exit automatically when the window is closed.
ExitApp
