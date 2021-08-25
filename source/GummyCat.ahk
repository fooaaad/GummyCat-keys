#NoEnv
SetKeyDelay, 0, 50
#SingleInstance force
#NoEnv
setdefaultkeyboard(0x0409)
SetWorkingDir %A_ScriptDir%
#Persistent
#InputLevel, 1
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
#Include VA.ahk
filecreatedir,%A_workingDir%\Gummyfiles
setworkingdir,%A_workingDir%\Gummyfiles
fileInstall,Gummyfiles\panic.exe,%A_WorkingDir%\panic.exe,1
tooleytipe(msg, timer = 0){
    Gui Destroy
    Gui, -Caption 
    Gui, Color, c202020
    Gui, +ToolWindow
    Gui, Font, cffffff
    Gui, Font, S12
    Gui, Add, text,, %msg%
	Gui, +AlwaysOnTop +Owner
    Gui, Show, NoActivate xCenter yCenter  NA
	if (timer != 0){
		SetTimer, RemoveToolTip, %timer%
		return
		RemoveToolTip:
		Gui, hide
        Gui Destroy
		return
	}
}

tooleytipee(msg, timer = 0){
    Gui Destroy
    Gui, -Caption 
    Gui, Color, c202020
    Gui, +ToolWindow
    Gui, Font, cffffff
    Gui, Add, text,, %msg%
	Gui, +AlwaysOnTop +Owner
    Gui, Show, NoActivate y0 NA
	if (timer != 0){
		SetTimer, RemoveToolTipe, %timer%
		return
		RemoveToolTipe:
		Gui, hide
        Gui Destroy
		return
	}
}


Gui, tip: -Caption 
Gui, tip: Color, cFF56BA
Gui, tip: +ToolWindow
Gui, tip: Font, cFF56BA
Gui, tip: Add, text,, K
Gui, tip: +AlwaysOnTop +Owner





;Script-addons/setAudio_output.ahk
Devices := {}
IMMDeviceEnumerator := ComObjCreate("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")

; IMMDeviceEnumerator::EnumAudioEndpoints
; eRender = 0, eCapture, eAll
; 0x1 = DEVICE_STATE_ACTIVE
DllCall(NumGet(NumGet(IMMDeviceEnumerator+0)+3*A_PtrSize), "UPtr", IMMDeviceEnumerator, "UInt", 0, "UInt", 0x1, "UPtrP", IMMDeviceCollection, "UInt")
ObjRelease(IMMDeviceEnumerator)

; IMMDeviceCollection::GetCount
DllCall(NumGet(NumGet(IMMDeviceCollection+0)+3*A_PtrSize), "UPtr", IMMDeviceCollection, "UIntP", Count, "UInt")
Loop % (Count)
{
    ; IMMDeviceCollection::Item
    DllCall(NumGet(NumGet(IMMDeviceCollection+0)+4*A_PtrSize), "UPtr", IMMDeviceCollection, "UInt", A_Index-1, "UPtrP", IMMDevice, "UInt")

    ; IMMDevice::GetId
    DllCall(NumGet(NumGet(IMMDevice+0)+5*A_PtrSize), "UPtr", IMMDevice, "UPtrP", pBuffer, "UInt")
    DeviceID := StrGet(pBuffer, "UTF-16"), DllCall("Ole32.dll\CoTaskMemFree", "UPtr", pBuffer)

    ; IMMDevice::OpenPropertyStore
    ; 0x0 = STGM_READ
    DllCall(NumGet(NumGet(IMMDevice+0)+4*A_PtrSize), "UPtr", IMMDevice, "UInt", 0x0, "UPtrP", IPropertyStore, "UInt")
    ObjRelease(IMMDevice)

    ; IPropertyStore::GetValue
    VarSetCapacity(PROPVARIANT, A_PtrSize == 4 ? 16 : 24)
    VarSetCapacity(PROPERTYKEY, 20)
    DllCall("Ole32.dll\CLSIDFromString", "Str", "{A45C254E-DF1C-4EFD-8020-67D146A850E0}", "UPtr", &PROPERTYKEY)
    NumPut(14, &PROPERTYKEY + 16, "UInt")
    DllCall(NumGet(NumGet(IPropertyStore+0)+5*A_PtrSize), "UPtr", IPropertyStore, "UPtr", &PROPERTYKEY, "UPtr", &PROPVARIANT, "UInt")
    DeviceName := StrGet(NumGet(&PROPVARIANT + 8), "UTF-16")    ; LPWSTR PROPVARIANT.pwszVal
    DllCall("Ole32.dll\CoTaskMemFree", "UPtr", NumGet(&PROPVARIANT + 8))    ; LPWSTR PROPVARIANT.pwszVal
    ObjRelease(IPropertyStore)

    ObjRawSet(Devices, DeviceName, DeviceID)
}




audio_output(audio_output_name)
    {
       global Devices
        For DeviceName, DeviceID in Devices
            If (InStr(DeviceName, audio_output_name)){
                IPolicyConfig := ComObjCreate("{870af99c-171d-4f9e-af0d-e63df40c2bc9}", "{F8679F50-850A-41CF-9C72-430F290290C8}")
                DllCall(NumGet(NumGet(IPolicyConfig+0)+13*A_PtrSize), "UPtr", IPolicyConfig, "UPtr", &DeviceID, "UInt", 0, "UInt")
                ObjRelease(IPolicyConfig)
            }
        
    }
;####################################################################################################################################################################################################
;####################################################################################################################################################################################################
;####################################################################################################################################################################################################
;####################################################################################################################################################################################################
;####################################################################################################################################################################################################
;####################################################################################################################################################################################################
;####################################################################################################################################################################################################
;####################################################################################################################################################################################################

Suspend, On
;##############################################################################################################################
;##############################################################################################################################
;##############################################################################################################################
;##############################################################################################################################
global FORCE := 1
global RESISTANCE := 0.982

global VELOCITY_X := 0
global VELOCITY_Y := 0



Accelerate(velocity, pos, neg) {
  If (pos == 0 && neg == 0) {
    Return 0
  }
  ; smooth deceleration :)
  Else If (pos + neg == 0) {
    Return velocity * 0.666
  }
  ; physicszzzzz
  Else {
    Return velocity * RESISTANCE + FORCE * (pos + neg)
  }
}
MoveCursor() {
        LEFT := 0
        DOWN := 0
        UP := 0
        RIGHT := 0

        UP := UP -  GetKeyState("w", "P")
        LEFT := LEFT - GetKeyState("a", "P")
        DOWN := DOWN + GetKeyState("s", "P")
        RIGHT := RIGHT + GetKeyState("d", "P")

        VELOCITY_X := Accelerate(VELOCITY_X, LEFT, RIGHT)
        VELOCITY_Y := Accelerate(VELOCITY_Y, UP, DOWN)

        MouseMove, %VELOCITY_X%, %VELOCITY_Y%, 0, R
}
;##############################################################################################################################
;#############################################################################################################################
;##############################################################################################################################
;############################################################################################################################
MonitorLeftEdge() {
  mx := 0
  CoordMode, Mouse, Screen
  MouseGetPos, mx
  monitor := (mx // A_ScreenWidth)

  return monitor * A_ScreenWidth
}




if FileExist("settings.ini"){
Filereadline, line2, settings.ini, 2
Filereadline, line4, settings.ini, 4
Filereadline, line6, settings.ini, 6
Hotkey, % "*" line2 , key1
Hotkey, % "*" line2 " up" , key2
}else {
FileAppend, #toggle-hold key`n, settings.ini
FileAppend, f23`n, settings.ini 
FileAppend, #output 1`n, settings.ini 
FileAppend, Speakers`n, settings.ini 
FileAppend, #output 2`n, settings.ini 
FileAppend, Nvidia`n, settings.ini 
reload
return
}
;inputttttttt

key2:
Suspend, On
Gui, tip: hide 
SetTimer, MoveCursor, off
return
key1:
Suspend, Off
Gui, tip: Show, NoActivate y-22 x960 NA
SetTimer, MoveCursor, 1
return

OnWinActiveChange()
OnWinActiveChange()
{
	static _ := DllCall("user32\SetWinEventHook", UInt,0x3, UInt,0x3, Ptr,0, Ptr,RegisterCallback("OnWinActiveChange"), UInt,0, UInt,0, UInt,0, Ptr)
    global valuee := []
    WinGet, yoy, processname, % "ahk_id " WinExist("A")
    for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
    {
        if (process.Name = yoy){
           if (GetVolumeObject(process.processId)){
                valuee.Push(process.processId)
            }
        }
    }
    While GetKeyState(line2)
    Sleep, 10
    return
}


,::
wheeldown::
for i, element in valuee
{
    SetAppVolume(element, GetAppVolume(element) + 5)
    tooleytipe(GetAppVolume(element),2000)
}
return

.::
wheelup::
for i, element in valuee
{
    SetAppVolume(element, GetAppVolume(element) - 5)
    tooleytipe(GetAppVolume(element),2000)
}
return

o::
for i, element in valuee
{
    if (GetAppVolume(element) != 0){
    audiowas = GetAppVolume(element)
    SetAppVolume(element, 0)
    tooleytipe("mute",2000)
    }else {
    SetAppVolume(element, audiowas)
    tooleytipe("unmute",2000)
    }

}
return

GetAppVolume(PID)
{
    Local MasterVolume := ""

    IMMDeviceEnumerator := ComObjCreate("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")
    DllCall(NumGet(NumGet(IMMDeviceEnumerator+0)+4*A_PtrSize), "UPtr", IMMDeviceEnumerator, "UInt", 0, "UInt", 1, "UPtrP", IMMDevice, "UInt")
    ObjRelease(IMMDeviceEnumerator)

    VarSetCapacity(GUID, 16)
    DllCall("Ole32.dll\CLSIDFromString", "Str", "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}", "UPtr", &GUID)
    DllCall(NumGet(NumGet(IMMDevice+0)+3*A_PtrSize), "UPtr", IMMDevice, "UPtr", &GUID, "UInt", 23, "UPtr", 0, "UPtrP", IAudioSessionManager2, "UInt")
    ObjRelease(IMMDevice)

    DllCall(NumGet(NumGet(IAudioSessionManager2+0)+5*A_PtrSize), "UPtr", IAudioSessionManager2, "UPtrP", IAudioSessionEnumerator, "UInt")
    ObjRelease(IAudioSessionManager2)

    DllCall(NumGet(NumGet(IAudioSessionEnumerator+0)+3*A_PtrSize), "UPtr", IAudioSessionEnumerator, "UIntP", SessionCount, "UInt")
    Loop % SessionCount
    {
        DllCall(NumGet(NumGet(IAudioSessionEnumerator+0)+4*A_PtrSize), "UPtr", IAudioSessionEnumerator, "Int", A_Index-1, "UPtrP", IAudioSessionControl, "UInt")
        IAudioSessionControl2 := ComObjQuery(IAudioSessionControl, "{BFB7FF88-7239-4FC9-8FA2-07C950BE9C6D}")
        ObjRelease(IAudioSessionControl)

        DllCall(NumGet(NumGet(IAudioSessionControl2+0)+14*A_PtrSize), "UPtr", IAudioSessionControl2, "UIntP", ProcessId, "UInt")
        If (PID == ProcessId)
        {
            ISimpleAudioVolume := ComObjQuery(IAudioSessionControl2, "{87CE5498-68D6-44E5-9215-6DA47EF883D8}")
            DllCall(NumGet(NumGet(ISimpleAudioVolume+0)+4*A_PtrSize), "UPtr", ISimpleAudioVolume, "FloatP", MasterVolume, "UInt")
            ObjRelease(ISimpleAudioVolume)
        }
        ObjRelease(IAudioSessionControl2)
    }
    ObjRelease(IAudioSessionEnumerator)

    Return Round(MasterVolume * 100)
}

SetAppVolume(PID, MasterVolume)    ; WIN_V+
{
    MasterVolume := MasterVolume > 100 ? 100 : MasterVolume < 0 ? 0 : MasterVolume

    IMMDeviceEnumerator := ComObjCreate("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")
    DllCall(NumGet(NumGet(IMMDeviceEnumerator+0)+4*A_PtrSize), "UPtr", IMMDeviceEnumerator, "UInt", 0, "UInt", 1, "UPtrP", IMMDevice, "UInt")
    ObjRelease(IMMDeviceEnumerator)

    VarSetCapacity(GUID, 16)
    DllCall("Ole32.dll\CLSIDFromString", "Str", "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}", "UPtr", &GUID)
    DllCall(NumGet(NumGet(IMMDevice+0)+3*A_PtrSize), "UPtr", IMMDevice, "UPtr", &GUID, "UInt", 23, "UPtr", 0, "UPtrP", IAudioSessionManager2, "UInt")
    ObjRelease(IMMDevice)

    DllCall(NumGet(NumGet(IAudioSessionManager2+0)+5*A_PtrSize), "UPtr", IAudioSessionManager2, "UPtrP", IAudioSessionEnumerator, "UInt")
    ObjRelease(IAudioSessionManager2)

    DllCall(NumGet(NumGet(IAudioSessionEnumerator+0)+3*A_PtrSize), "UPtr", IAudioSessionEnumerator, "UIntP", SessionCount, "UInt")
    Loop % SessionCount
    {
        DllCall(NumGet(NumGet(IAudioSessionEnumerator+0)+4*A_PtrSize), "UPtr", IAudioSessionEnumerator, "Int", A_Index-1, "UPtrP", IAudioSessionControl, "UInt")
        IAudioSessionControl2 := ComObjQuery(IAudioSessionControl, "{BFB7FF88-7239-4FC9-8FA2-07C950BE9C6D}")
        ObjRelease(IAudioSessionControl)

        DllCall(NumGet(NumGet(IAudioSessionControl2+0)+14*A_PtrSize), "UPtr", IAudioSessionControl2, "UIntP", ProcessId, "UInt")
        If (PID == ProcessId)
        {
            ISimpleAudioVolume := ComObjQuery(IAudioSessionControl2, "{87CE5498-68D6-44E5-9215-6DA47EF883D8}")
            DllCall(NumGet(NumGet(ISimpleAudioVolume+0)+3*A_PtrSize), "UPtr", ISimpleAudioVolume, "Float", MasterVolume/100.0, "UPtr", 0, "UInt")
            ObjRelease(ISimpleAudioVolume)
        }
        ObjRelease(IAudioSessionControl2)
    }
    ObjRelease(IAudioSessionEnumerator)
}

GetVolumeObject(Param = 0)
{
    static IID_IASM2 := "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}"
    , IID_IASC2 := "{bfb7ff88-7239-4fc9-8fa2-07c950be9c6d}"
    , IID_ISAV := "{87CE5498-68D6-44E5-9215-6DA47EF883D8}"
    
    ; Get PID from process name
    if Param is not Integer
    {
        Process, Exist, %Param%
        Param := ErrorLevel
    }
    
    ; GetDefaultAudioEndpoint
    DAE := VA_GetDevice()
    
    ; activate the session manager
    VA_IMMDevice_Activate(DAE, IID_IASM2, 0, 0, IASM2)
    
    ; enumerate sessions for on this device
    VA_IAudioSessionManager2_GetSessionEnumerator(IASM2, IASE)
    VA_IAudioSessionEnumerator_GetCount(IASE, Count)
    
    ; search for an audio session with the required name
    Loop, % Count
    {
        ; Get the IAudioSessionControl object
        VA_IAudioSessionEnumerator_GetSession(IASE, A_Index-1, IASC)
        
        ; Query the IAudioSessionControl for an IAudioSessionControl2 object
        IASC2 := ComObjQuery(IASC, IID_IASC2)
        ObjRelease(IASC)
        
        ; Get the session's process ID
        VA_IAudioSessionControl2_GetProcessID(IASC2, SPID)
        
        ; If the process name is the one we are looking for
        if (SPID == Param)
        {
            ; Query for the ISimpleAudioVolume
            ISAV := ComObjQuery(IASC2, IID_ISAV)
            
            ObjRelease(IASC2)
            break
        }
        ObjRelease(IASC2)
    }
    ObjRelease(IASE)
    ObjRelease(IASM2)
    ObjRelease(DAE)
    return ISAV
}
;############################################
;############################################
;############################################
;############################################
;############################################

.::RAlt
w:: Return
a:: Return
s:: Return
d:: Return


~Lshift & w::
x := 0
CoordMode, Mouse, Screen
MouseGetPos, x
MouseMove, x,0
Return
~Lshift & a::
x := MonitorLeftEdge() + 2
y := 0
CoordMode, Mouse, Screen
MouseGetPos,,y
MouseMove, x,y
Return
~Lshift & s::
x := 0
CoordMode, Mouse, Screen
MouseGetPos, x
MouseMove, x,(A_ScreenHeight - 0)
Return
~Lshift & d::
x := MonitorLeftEdge() + A_ScreenWidth - 2
y := 0
CoordMode, Mouse, Screen
MouseGetPos,,y
MouseMove, x,y
Return


~Lshift & e::
wx := 0
wy := 0
width := 0
WinGetPos,wx,wy,width,,A
center := wx + width - 180
y := wy + 12
;MsgBox, Hello %width% %center%de 
MouseMove, center, y
Click, Down
return


r:: Click, WheelUp
f:: Click, WheelDown


space:: LButton
v:: Click, Down
c::RButton
z:: Click, Down, right
x:: MButton


esc::
WinGet, PID, PID, % "ahk_id " WinExist("A")
Process, Close, %PID%
Return

tab::WinClose, A

1::f1
2::f2
3::f3
4::f4
5::f5
6::f6
7::f7
8::f8
9::f9
0::f10
-::f11
=::f12

g::PrintScreen
b::ScrollLock

h::Del
y::Insert
u::Home
j::end
i::PgUp
k::PgDn


^backspace::
Suspend, On
Gui, tip: hide 
SetTimer, MoveCursor, off
KeyWait, backspace, T1
IF !ErrorLevel
Return
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
return

backspace::
KeyWait, backspace, T1
IF !ErrorLevel
Return
shutdown, 1
return

+backspace::
KeyWait, backspace, T1
IF !ErrorLevel
Return
Shutdown, 2
return

[::Volume_Up
]::Volume_Down
\::Volume_Mute

p::Media_Stop
l::Media_Prev
SC027::Media_Play_Pause
SC028::Media_Next

t::
If FileExist("2output.ini"){
	audio_output(line4)
	tooleytipee(line4,1000)
	FileDelete, %A_WorkingDir%\*output.ini
	FileAppend,, %A_WorkingDir%\1output.ini
	return
}
else{
	audio_output(line6)
	tooleytipee(line6,1000)
	FileDelete, %A_WorkingDir%\*output.ini
	FileAppend,, %A_WorkingDir%\2output.ini
	return
}


Esc::`
;panic button
n::
panic := panic<1 ? 1:0
If panic = 1
	{
	Run, panic.exe,,, panicc
	}
Else
	{
	Process, close, %panicc%
	}
Return



;日本語############################################################=########


IME_SET(ha, WinTitle="A")    {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  Int, ha) ;lParam  : 0 or 1
		  return
}
IME_GET(WinTitle="A")  {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
          ,  Int, 0)      ;lParam  : 0
		  return
}

SetDefaultKeyboard(LocaleID){
	Static SPI_SETDEFAULTINPUTLANG := 0x005A, SPIF_SENDWININICHANGE := 2
	
	Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", LocaleID), "Int", 0)
	VarSetCapacity(binaryLocaleID, 4, 0)
	NumPut(LocaleID, binaryLocaleID)
	DllCall("SystemParametersInfo", "UInt", SPI_SETDEFAULTINPUTLANG, "UInt", 0, "UPtr", &binaryLocaleID, "UInt", SPIF_SENDWININICHANGE)
	
	WinGet, windows, List
	Loop % windows {
		PostMessage 0x50, 0, % Lan, , % "ahk_id " windows%A_Index%
	}
}
return
GetKeyboardLanguage()
{
	if !KBLayout := DllCall("user32.dll\GetKeyboardLayout")
		return false
	
	return KBLayout & 0xFFFF
}


e::
If (IME_GET()  = 1)
	{
	PostMessage 0x50, 0, 0x4110411,, "A"
    IME_SET(0)
	SetDefaultKeyboard(0x0409)
	return
}
else{
	SetDefaultKeyboard(0x0411)
    IME_SET(1)
	return
}

q::
if !LangID := GetKeyboardLanguagee(WinActive("A"))
{
	return
}
 
if (LangID = 0x0409){
    SetDefaultKeyboard(0x0401)
    return
}
else
    setdefaultkeyboard(0x0409)
return
 
GetKeyboardLanguagee(_hWnd=0)
{
	if !_hWnd
		ThreadId=0
	else
		if !ThreadId := DllCall("user32.dll\GetWindowThreadProcessId", "Ptr", _hWnd, "UInt", 0, "UInt")
			return false
	
	if !KBLayout := DllCall("user32.dll\GetKeyboardLayout", "UInt", ThreadId, "UInt")
		return false
	
	return KBLayout & 0xFFFF
}
if (LangID = 0x0409){
    SetDefaultKeyboard(0x0401)
    return
}
else{
    setdefaultkeyboard(0x0409)
    return
}


/::up
Ralt::left
RCtrl::right
AppsKey::down
