#NoEnv
SetKeyDelay, 0, 50
#SingleInstance force
#NoEnv
SetWorkingDir %A_ScriptDir%
#Persistent
#InputLevel, 1
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#installKeybdHook
#UseHook On
#notrayicon
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


Gui, tip: -Caption 
Gui, tip: Color, c171D1C
Gui, tip: +ToolWindow
Gui, tip: Font, c171D1C
Gui, tip: Add, text,, K
Gui, tip: +AlwaysOnTop +Owner
Gui, tip: Show, NoActivate y-22 x920 NA

Rbutton::send !{Tab}  
