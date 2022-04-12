REM @echo off

set DIR=%~dp0
del "%DIR%lang.exe" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\lang.lnk"

"%PROGRAMFILES%\AutoHotkey\Compiler\Ahk2Exe.exe" /in "%DIR%lang.ahk" /out "%DIR%lang.exe"

mklink "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\lang.lnk" "%DIR%lang.exe"

"%DIR%lang.exe"
