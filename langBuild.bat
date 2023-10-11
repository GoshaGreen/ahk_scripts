REM @echo off

set DIR=%~dp0
del "%DIR%lang.exe" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\lang.lnk"

@REM "%PROGRAMFILES%\AutoHotkey\Compiler\Ahk2Exe.exe" /in "%DIR%lang2.ahk" /out "%DIR%lang.exe"

set COMPILLER_PATH="%AppData%\..\Local\Programs\AutoHotkey\Compiler\"
set COMPILLER_PATH="C:\Program Files\AutoHotkey\Compiler"
%COMPILLER_PATH%"\Ahk2Exe.exe" /in "%DIR%lang2.ahk" /out "%DIR%lang.exe"

mklink "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\lang.lnk" "%DIR%lang.exe"

call "%DIR%lang.exe"
