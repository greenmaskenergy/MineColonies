@echo off
setlocal enabledelayedexpansion
for /f "delims=" %%A in ('dir /b *.jar ^| findstr /RC:"-[0-9].*$"') do (
        set "line=%%~nxA"
        for %%i in ("!line:-=\!") do set "final=%%~pi"
        set "final=!final:~0,-1!"
        set "final=!final:~1!"
        echo !final:\=-!
)
pause