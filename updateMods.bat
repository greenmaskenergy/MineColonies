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
set "RawPath=%CD%"
for %%I in (.) do set Parent=%%~nxI
for /D %%D in ("%RawPath%") do (
    set "ColorRawPath=%%~dpD"
)


if %Parent% == mods (
    echo [36m%ColorRawPath%[0m[32m%Parent%[0m
    echo.
    echo.
    echo.
    pause>nul|set/p =[36mpress any key to start[0m downloading missing mods.
    echo.Downloader started from %RawPath%> latestLog.txt
    echo.%date% %time% >> latestLog.txt
    goto dowloadingMissingMods
) else (
    echo [36m%ColorRawPath%[0m[31m%Parent%[0m
    echo.
    echo [91mWrong directory this downloader needs to be placed in "/mod" Folder[0m
    echo.
    echo.
    pause>nul|set/p =[36mpress any key to exit[0m 
    EXIT /B 0
)




:dowloadingMissingMods
set /a progress=0
echo Downloading ModListFile (mods) >> latestLog.txt
echo --------------------------------------------------------------------------------------------- >> latestLog.txt
echo.  TimeStamp   progress  status    modname >> latestLog.txt
echo --------------------------------------------------------------------------------------------- >> latestLog.txt
bitsadmin.exe /transfer "" /priority FOREGROUND https://onehit.eu/MC_ModLists/MineColonies/mods %cd%/mods
REM >> latestLog.txt
set "cmd=findstr /R /N "^^" %cd%\mods | find /C ":""
for /f %%a in ('!cmd!') do set ModCount=%%a

for /F "tokens=*" %%A in (%cd%\mods) do (
    set /a progress=progress+1
    REM echo Mod Progress: !progress! / %ModCount% >> latestLog.txt

if not exist %cd%\%%A (
    echo [%time%]  !progress! / %ModCount%   Install  %%A >> latestLog.txt
    bitsadmin.exe /transfer "Mod (!progress! / !ModCount!): %%A"  /priority FOREGROUND https://github.com/greenmaskenergy/MineColonies/raw/master/%%A %cd%\%%A
) else (
    echo [%time%]  !progress! / %ModCount%   Skipped   %%A >> latestLog.txt
)
)
echo --------------------------------------------------------------------------------------------- >> latestLog.txt
echo update done! >> latestLog.txt
REM timeout /t 5 /nobreak >nul >> latestLog.txt
echo.
echo.
pause>nul|set/p =[32mDownloader Done![0m press any key to close
echo closing downloader >> latestLog.txt
EXIT /B 0
