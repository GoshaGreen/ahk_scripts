REM @echo off

set DIR=%~dp0
del "%DIR%lang.exe" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\lang.lnk"

@REM "%PROGRAMFILES%\AutoHotkey\Compiler\Ahk2Exe.exe" /in "%DIR%lang2.ahk" /out "%DIR%lang.exe"

"%AppData%\..\Local\Programs\AutoHotkey\Compiler\Ahk2Exe.exe" /in "%DIR%lang2.ahk" /out "%DIR%lang.exe"

mklink "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\lang.lnk" "%DIR%lang.exe"

call "%DIR%lang.exe"
