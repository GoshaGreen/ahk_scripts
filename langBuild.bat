REM @echo off

set DIR=%~dp0
del "%DIR%lang.exe" "%APP_DATA%\Microsoft\Windows\Start Menu\Programs\Startup\lang.lnk"

"%PROGRAMFILES%\AutoHotkey\Compiler\Ahk2Exe.exe" /in "%DIR%lang.ahk" /out "%DIR%lang.exe"

mklink "%APP_DATA%\Microsoft\Windows\Start Menu\Programs\Startup\lang.lnk" "%DIR%lang.exe"

"%DIR%lang.exe"
