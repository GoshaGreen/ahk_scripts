
#SingleInstance force
#Warn  ; Enable warnings to assist with detecting common errors.
#Requires AutoHotkey v2.0

; script descr
; 0. test print
; 1. toggle capslock with double click
; 2. mouse move by ctrl+z
; 3. change rus/eng keybard by pressing rctrl/lctrl
; 4.1 Convert Upper<->Lower case by presing SHIFT+BREAK
; 4.2 Convert selected text english<->russian by presing BREAK using clipboard
; 5. AlwayOnTop toggle by pressing CTRL+ALT+T
; 6. Input German letters by double click shifts


; ============
; 0. Test print
; ============
LWin & n::MsgBox("Itswor king")


; ============
; 1. toggle capslock with double click
; ============
CapsLock:: {
    If (A_ThisHotkey == A_PriorHotkey && A_TimeSincePriorHotkey < 300)
    {
        SetCapsLockState !GetKeyState("CapsLock", "T")
    }
}

; ============
; 2. mouse move by win+z
; ============
Global KeepWinZRunning := false
#MaxThreadsPerHotkey 2
#z::{
    global
    if KeepWinZRunning
    {
        KeepWinZRunning := false
        return
    }
    ; Otherwise:
    KeepWinZRunning := true
    Loop
    {
        MouseMove 1, 1, 50, "R"
        ToolTip("Press Win-Z again to stop this from flashing.")
        Sleep( 500)
        MouseMove(-1, -1, 50, "R")
        Sleep( 500)
        ToolTip
        if not KeepWinZRunning 
            break
    }
    KeepWinZRunning := false
}

; ============
; 3. change rus/eng keybard by pressing rctrl/lctrl
; ============
~RCtrl::
{
    SetDefaultKeyboard(0x0419) ; Russian
}

~LCtrl::
{
    SetDefaultKeyboard(0x0409) ; english-US
}

SetDefaultKeyboard(LocaleID){ ; for language codes: https://www.autohotkey.com/docs/misc/Languages.htm
    SPI_SETDEFAULTINPUTLANG := 0x005A
    SPIF_SENDWININICHANGE := 2
    Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", LocaleID), "Int", 0)
    err := DllCall("SystemParametersInfo", "UInt", SPI_SETDEFAULTINPUTLANG, "UInt", 0, "Str", Format("Lan0x{:04x}", LocaleID), "UInt", SPIF_SENDWININICHANGE)
    if (err != 0) {
        err := DllCall("GetLastError")
        MsgBox(Format("Error occured: 0x{:08x}", err))
    }
    ids := WinGetList(,,)
    for this_id in ids {
        PostMessage(0x50, 0, Lan, , Format("ahk_id 0x{:08x}", this_id))
    }
}

; ============
; 4.1 Convert Upper<->Lower case by presing SHIFT+BREAK
; ============


; ============
; 4.2 Convert selected text english<->russian by presing BREAK using clipboard
; ============


; ============
; 5. AlwayOnTop toggle by pressing CTRL+ALT+T
; ============
!^t:: WinSetAlwaysOnTop(-1, "A")

; ============
; 6. Input German letters by double click shifts
; ============

Global umlautPrevKey := ""

; #IfWinNotActive ahk_exe mstsc.exe
~$RShift::{
    global
    lea := SubStr(A_PriorKey, 1, 1)
    If (lea ~= "u|a|s|o") {
        umlautPrevKey := lea
        return
    }
    
    If (A_ThisHotkey != A_PriorHotkey) || (A_TimeSincePriorHotkey > 1000) || !(umlautPrevKey ~= "u|a|s|o") {
        umlautPrevKey := ""
        return
    }

    keystr := "uUoOsSaA"
    questr := "üÜöÖßßäÄ" 
    ; questr := "12345678" 
    ClipSaved := ClipboardAll()
    A_Clipboard := ""
    Send "{Shift down}"
    Send "{Left}"
    Send "{Shift Up}"
    KeyWait("Shift")
    Send "^c"
    ClipWait
    lea := A_Clipboard

    loop Parse keystr {
        if (StrCompare(lea, A_LoopField, "On") == 0) {
            lea := SubStr(questr, A_Index, 1)
            Send("{BackSpace}")
            Send(lea)
            break
        }
    }

    A_Clipboard := ClipSaved
    ClipSaved := ""
}
