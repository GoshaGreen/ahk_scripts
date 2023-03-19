; script descr
; 1. toggle capslock with double click
; 2. mouse move by ctrl+z
; 3. change rus/eng keybard by pressing rctrl/lctrl
; 4.1 Convert Upper<->Lower case by presing SHIFT+BREAK
; 4.2 Convert selected text english<->russian by presing BREAK using clipboard
; 5. AlwayOnTop toggle by pressing CTRL+ALT+T
; 6. Input German letters by double click shifts

#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ============
; 1. toggle capslock with double click
; ============
capsToggle := 0
SetCapsLockState, Off
return

#IfWinNotActive ahk_exe mstsc.exe
*CapsLock::
	If ((A_ThisHotkey = A_Priorhotkey) && (A_TimeSincePriorHotkey < 300))
		SetCapsLockState, % ((capsToggle := !capsToggle) ? "On" : "Off")
	Else
		return ; Change this to whatever you want the key to do when held.
return

; ============
; 2. mouse move by win+z
; ============
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
	MouseMove, -1, -1, 50, R
	Sleep 500
	ToolTip
    if not KeepWinZRunning 
        break
}
KeepWinZRunning := false
return

; ============
; 3. change rus/eng keybard by pressing rctrl/lctrl
; ============
#IfWinNotActive ahk_exe mstsc.exe
RCtrl::
	Send {RControl down}
	SetDefaultKeyboard(0x0419) ; Russian
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

SetDefaultKeyboard(LocaleID){ ; for language codes: https://www.autohotkey.com/docs/misc/Languages.htm
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

; ============
; 4.1 Convert Upper<->Lower case by presing SHIFT+BREAK
; ============
#IfWinNotActive ahk_exe mstsc.exe
+Break::
	temp1 := ClipboardAll
	keystr := "QWERTYUIOP[]ASDFGHJKLZXCVBNMЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ" . "qwertyuiop[]asdfghjklzxcvbnmйцукенгшщзхъфывапролджэячсмитьбюё"
	questr := "qwertyuiop[]asdfghjklzxcvbnmйцукенгшщзхъфывапролджэячсмитьбюё" . "QWERTYUIOP[]ASDFGHJKLZXCVBNMЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ"
	Send ^x
	ClipWait
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
	temp1 := ""
return

; ============
; 4.2 Convert selected text english<->russian by presing BREAK using clipboard
; ============
#IfWinNotActive ahk_exe mstsc.exe
Break::
	temp1 := ClipboardAll
	keystr := "qwertyuiop[]" . "asdfghjkl`;`'`\" . "zxcvbnm,.`/" . "QWERTYUIOP{}" . "ASDFGHJKL`:""|ZXCVBNM<>?" . "ёйцукенгшщзхъ"  . "фывапролджэ\"    . "ячсмитьбю."  . "ЁЙЦУКЕНГШЩЗХЪ" . "ФЫВАПРОЛДЖЭj/ЯЧСМИТЬБЮ."    . "``~{!}@#$^&"   . "ёЁ{!}""№`;`:?"
	questr := "йцукенгшщзхъ" . "фывапролджэ\"    . "ячсмитьбю."  . "ЙЦУКЕНГШЩЗХЪ" . "ФЫВАПРОЛДЖЭ/ЯЧСМИТЬБЮ."   . "``qwertyuiop[]" . "asdfghjkl`;`'`\" . "zxcvbnm,.`/" . "~QWERTYUIOP{}" . "ASDFGHJKL`:""""|ZXCVBNM<>?" . "ёЁ{!}""№`;`:?" . "``~{!}@#$^&"
	Send ^x
	ClipWait
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

; ============
; 5. AlwayOnTop toggle by pressing CTRL+ALT+T
; ============
!^t::  Winset, Alwaysontop, , A

; ============
; 6. Input German letters by double click shifts
; ============
umlautPrevKey := ""
return

#IfWinNotActive ahk_exe mstsc.exe
~$RShift::
	lea := SubStr(A_PriorKey, 1, 1)
	If (lea ~= "u|a|s|o") {
		umlautPrevKey := lea
		return
	}

	If (A_ThisHotkey != A_PriorHotkey) || (A_TimeSincePriorHotkey > 500) || !(umlautPrevKey ~= "u|a|s|o") {
		umlautPrevKey := ""
		return
	}

	keystr := "uUoOsSaA"
	questr := "üÜöÖßßäÄ"
	temp1 := ClipboardAll
	ClipWait
	Clipboard := ""
	Send {Shift Down}
	Send {Left}
	Send {Shift Up}
	KeyWait, Shift
	Send ^c
	ClipWait
	lea := SubStr(Clipboard, 1, 1)
	Loop, parse, keystr
	{
		if (lea == SubStr(A_LoopField,1,1))
		{
			lea := SubStr(questr, A_Index, 1)
			Send {BackSpace}
			Send %lea%
			break
		}
	}
	
	Clipboard := temp1
	temp1 := ""
return




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

; Test output
;^R::
;Send "`;``qwertyuiop[]asdfghjkl`;`'`\zxcvbnm,.`/~QWERTYUIOP{{}{}}ASDFGHJKL{:}"{|}ZXCVBNM<>?"{Enter}
;Send "`;ёйцукенгшщзхъфывапролджэ\ячсмитьбю.ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭ/ЯЧСМИТЬБЮ."
;return
