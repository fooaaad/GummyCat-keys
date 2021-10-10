#NoEnv
SetKeyDelay, 0, 50
#SingleInstance force
#NoEnv
#Persistent
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#installKeybdHook
#notrayicon
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

v1 = %1%
v2 = %2%
StringGetPos, pos, v1 , \, R
StringLeft, director, v1 , %pos%

if(v2 != "dir"){

    run %v1% , %director%
    exitapp

}
else {

    run %director%
    exitapp
}

