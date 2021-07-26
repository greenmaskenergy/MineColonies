@echo off
setlocal EnableDelayedExpansion
cls
title MineColonies Mod Downloader
echo by GreenMaskEnergy [90mversion 2.1[0m 
echo.
echo.
echo Will download only missing mods in the same directory as this is run from!
echo place in (minecraft)/mods folder and run there
echo =============================================================================
echo.
REM checking if parent folder is actualy called mods! to make sure it download to the right folder
REM setting the variable to the parent folder name
echo this downloader is located at:
echo.
set "RawPath=%~dp0"
for %%I in ("%~dp0") do for %%J in ("%%~dpI.") do set Parent=%%~nxJ
for /D %%D in ("%~dp0.") do (set "ColorRawPath=%%~dpD")


if %Parent% == mods (
    echo [36m%ColorRawPath%[0m[32m%Parent%[0m
    echo.
    echo.
    echo.
    pause>nul|set/p =[36mpress any key to start[0m downloading missing mods.
    echo.Downloader started from %RawPath%> %RawPath%/latestLog.txt
    echo.%date% %time% >> %RawPath%/latestLog.txt
    goto dowloadingMissingMods
) else (
    echo [36m%RawPath%[0m[31m%Parent%[0m
    echo.
    echo [91mWrong directory this downloader needs to be placed in "/mod" Folder[0m
    echo.
    echo.
    pause>nul|set/p =[36mpress any key to exit[0m 
    EXIT /B 0
)




:dowloadingMissingMods
set /a progress=0
echo Downloading ModListFile (mods) >> %RawPath%/latestLog.txt
echo --------------------------------------------------------------------------------------------- >> %RawPath%/latestLog.txt
echo.  TimeStamp   progress  status    modname >> %RawPath%/latestLog.txt
echo --------------------------------------------------------------------------------------------- >> %RawPath%/latestLog.txt
bitsadmin.exe /transfer "" /priority FOREGROUND https://onehit.eu/MC_ModLists/MineColonies/mods %~dp0/mods
REM >> %RawPath%/latestLog.txt
set "cmd=findstr /R /N "^^" %~dp0\mods | find /C ":""
for /f %%a in ('!cmd!') do set ModCount=%%a

for /F "tokens=*" %%A in (%~dp0\mods) do (
    set /a progress=progress+1
    REM echo Mod Progress: !progress! / %ModCount% >> %RawPath%/latestLog.txt

if not exist %~dp0\%%A (
    echo [%time%]  !progress! / %ModCount%   Install  %%A >> %RawPath%/latestLog.txt
    bitsadmin.exe /transfer "Mod (!progress! / !ModCount!): %%A"  /priority FOREGROUND https://github.com/greenmaskenergy/MineColonies/raw/master/%%A %~dp0\%%A
) else (
    echo [%time%]  !progress! / %ModCount%   Skipped   %%A >> %RawPath%/latestLog.txt
)
)
echo --------------------------------------------------------------------------------------------- >> %RawPath%/latestLog.txt
echo update done! >> %RawPath%/latestLog.txt
REM timeout /t 5 /nobreak >nul >> %RawPath%/latestLog.txt
echo.
echo.
pause>nul|set/p =[32mDownloader Done![0m press any key to close
echo closing downloader >> %RawPath%/latestLog.txt
EXIT /B 0
