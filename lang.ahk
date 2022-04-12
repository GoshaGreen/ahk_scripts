#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; ^Down::
; IfWinExist, ahk_class OSKMainClass
; {
; WinGet,WinState,MinMax,ahk_class OSKMainClass
; If WinState = -1
;     WinMaximize
; else
;     WinMinimize
; }
; else
;     Run, %windir%\system32\osk.exe
; return

; AlwayOnTop toggle by pressing CTRL+ALT+T
!^t::  Winset, Alwaysontop, , A

; toggle mouse moving by pressing WIN+Z 
#MaxThreadsPerHotkey 3
#z::
#MaxThreadsPerHotkey 1
if KeepWinZRunning
{
    KeepWinZRunning := false
    return
}
; Otherwise:
KeepWinZRunning := true
Loop
{
	MouseMove, 1, 1, 50, R
	ToolTip, Press Win-Z again to stop this from flashing.
    Sleep 500
    ToolTip	
	MouseMove, -1, -1, 50, R
	Sleep 500
    if not KeepWinZRunning 
        break
}
KeepWinZRunning := false
return

; turn russian language by pressing Right CTRL
#IfWinNotActive ahk_exe mstsc.exe
RCtrl::
	Send {RControl down}
	SetDefaultKeyboard(0x0419) ; Russians
return

#IfWinNotActive ahk_exe mstsc.exe
RCtrl up::
	Send {RControl up}
return

; turn english language by pressing Right CTRL
#IfWinNotActive ahk_exe mstsc.exe
LCtrl::
	Send {LControl down}
	SetDefaultKeyboard(0x0409) ; english-US
return

#IfWinNotActive ahk_exe mstsc.exe
LCtrl Up::
	Send {LControl up}
return 

; Convert Upper<->Lower case by presing SHIFT+BREAK
#IfWinNotActive ahk_exe mstsc.exe
+Break::
	temp1 := clipboard
	keystr := "QWERTYUIOP[]ASDFGHJKLZXCVBNMЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ" . "qwertyuiop[]asdfghjklzxcvbnmйцукенгшщзхъфывапролджэячсмитьбюё"
	questr := "qwertyuiop[]asdfghjklzxcvbnmйцукенгшщзхъфывапролджэячсмитьбюё" . "QWERTYUIOP[]ASDFGHJKLZXCVBNMЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ"
	Send {Ctrl down}x{Ctrl up}
	Loop, parse, clipboard
	{
		lea := SubStr(A_LoopField, 1, 1)
		Loop, parse, keystr
		{
			if (lea == SubStr(A_LoopField,1,1)) 
			{
				lea := SubStr(questr, A_Index, 1)
				break
			}
		}
		Send %lea%
	}
	clipboard := temp1
return

; Convert selected text english<->russian by presing BREAK using clipboard
#IfWinNotActive ahk_exe mstsc.exe
Break::
	temp1 := clipboard
	keystr := "qwertyuiop[]" . "asdfghjkl`;`'`\" . "zxcvbnm,.`/" . "QWERTYUIOP{}" . "ASDFGHJKL`:""|ZXCVBNM<>?" . "ёйцукенгшщзхъ"  . "фывапролджэ\"    . "ячсмитьбю."  . "ЁЙЦУКЕНГШЩЗХЪ" . "ФЫВАПРОЛДЖЭj/ЯЧСМИТЬБЮ."    . "``~{!}@#$^&"   . "ёЁ{!}""№`;`:?"
	questr := "йцукенгшщзхъ" . "фывапролджэ\"    . "ячсмитьбю."  . "ЙЦУКЕНГШЩЗХЪ" . "ФЫВАПРОЛДЖЭ/ЯЧСМИТЬБЮ."   . "``qwertyuiop[]" . "asdfghjkl`;`'`\" . "zxcvbnm,.`/" . "~QWERTYUIOP{}" . "ASDFGHJKL`:""""|ZXCVBNM<>?" . "ёЁ{!}""№`;`:?" . "``~{!}@#$^&"
	Send {Ctrl down}x{Ctrl up}
	Loop, parse, clipboard
	{
		lea := SubStr(A_LoopField, 1, 1)
		Loop, parse, keystr
		{
			if (lea == SubStr(A_LoopField,1,1)) 
			{
				lea := SubStr(questr, A_Index, 1)
				break
			}
		}
		Send %lea%
	}
	clipboard := temp1
return

; capslock state change by doble click
capsToggle := 0
SetCapsLockState, Off
return

#IfWinNotActive ahk_exe mstsc.exe
*CapsLock::
	if ((A_ThisHotkey = A_Priorhotkey) && (A_TimeSincePriorHotkey < 300))
		SetCapsLockState, % ((capsToggle := !capsToggle) ? "On" : "Off")
	Else
		return ; Change this to whatever you want the key to do when held.
return

; Test output
;^R::
;Send "`;``qwertyuiop[]asdfghjkl`;`'`\zxcvbnm,.`/~QWERTYUIOP{{}{}}ASDFGHJKL{:}"{|}ZXCVBNM<>?"{Enter}
;Send "`;ёйцукенгшщзхъфывапролджэ\ячсмитьбю.ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭ/ЯЧСМИТЬБЮ."
;return

SetDefaultKeyboard(LocaleID){
	Global
	SPI_SETDEFAULTINPUTLANG := 0x005A
	SPIF_SENDWININICHANGE := 2
	Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", LocaleID), "Int", 0)
	VarSetCapacity(Lan%LocaleID%, 4, 0)
	NumPut(LocaleID, Lan%LocaleID%)
	DllCall("SystemParametersInfo", "UInt", SPI_SETDEFAULTINPUTLANG, "UInt", 0, "UPtr", &Lan%LocaleID%, "UInt", SPIF_SENDWININICHANGE)
	WinGet, windows, List
	Loop %windows% {
		PostMessage 0x50, 0, %Lan%, , % "ahk_id " windows%A_Index%
	}
}
return