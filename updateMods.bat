@echo off
setlocal enabledelayedexpansion
cls
title MineColonies Mod Downloader
echo by GreenMaskEnergy [90mversion 2.1[0m 
echo.
echo.
echo Will download only missing mods in the same directory as this is run from!
echo place in (minecraft)/mods folder and run there
echo =============================================================================
echo.
echo this downloader is located at:
echo.
set "RawPath=%~dp0"
for %%I in ("%~dp0") do for %%J in ("%%~dpI.") do set "Parent=%%~nxJ"
for /D %%D in ("%~dp0.") do (set "ColorRawPath=%%~dpD")
set "log=%RawPath%/latestLog.txt"
if %Parent% == mods (
    echo [36m%ColorRawPath%[0m[32m%Parent%[0m
    echo.
    echo.
    echo.
    pause>nul|set/p =[36mpress any key to start[0m downloading missing mods.
    echo --------------------------------------------------------------------------------------------- > "%log%"
    echo.Location 📁 %RawPath% >> "%log%"
    echo.Date     🕐 %date%>> "%log%"
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
set "modsfile=%RawPath%/mods"
set /a progress=0
echo --------------------------------------------------------------------------------------------- >> "%log%"
echo.  TimeStamp     Progress     Status      Modname >> "%log%"
echo --------------------------------------------------------------------------------------------- >> "%log%"
echo.[%time%]      /      ✅ Download    ModListFile (mods) >> "%log%"
bitsadmin.exe /transfer "" /priority FOREGROUND https://onehit.eu/MC_ModLists/MineColonies/mods "%RawPath%/mods"
echo. >> "%log%"
set "cmd=findstr /R /N "^^" "%RawPath%\mods" | find /C ":""
for /f %%a in ('!cmd!') do set ModCount=%%a
set "space=DEF"
set "modsSkipped=0"
set "modsDownloaded=0"
FOR /F "USEBACKQ TOKENS=*" %%A IN ("%RawPath%/mods") DO (
    set /a progress=!progress!+1
    if !progress! LSS 1000 (
        set "space="
        if !progress! LSS 100 (
            set "space= "
            if !progress! LSS 10 (
                set "space=  "
            )
        )
    )
    REM set spacer=" "*(%ModCount%)
    if not exist "%~dp0\%%~A" (
        set /a modsDownloaded=!modsDownloaded!+1
        echo [%time%]  !space!!progress! / %ModCount%   ✅ Download    %%A >> "%log%"
        bitsadmin.exe /transfer "Mod (!progress! / !ModCount!): %%A"  /priority FOREGROUND https://github.com/greenmaskenergy/MineColonies/raw/master/%%A "%RawPath%/%%A"
    ) else (
        set /a modsSkipped=!modsSkipped!+1
        echo [%time%]  !space!!progress! / %ModCount%   ❌ Skipped     %%A >> "%log%"
    )
)
echo --------------------------------------------------------------------------------------------- >> "%log%"
echo.Mods ✅ downloaded: !modsDownloaded! >> "%log%"
echo.Mods ❌ skipped:    !modsSkipped! >> "%log%"
cls
REM pause>nul|set/p =[32mDownloader Done![0m press any key to close
echo [92mDownloader Done![0m
echo.
echo [36mMods downloaded: !modsDownloaded! [0m
echo [33mMods skipped: !modsSkipped! [0m
echo.
echo closing in 5s
timeout 1 /nobreak >nul
cls
echo [92mDownloader Done![0m
echo.
echo [36mMods downloaded: !modsDownloaded! [0m
echo [33mMods skipped: !modsSkipped! [0m
echo.
echo closing in 4s
timeout 1 /nobreak >nul
cls
echo [92mDownloader Done![0m
echo.
echo [36mMods downloaded: !modsDownloaded! [0m
echo [33mMods skipped: !modsSkipped! [0m
echo.
echo closing in 3s
timeout 1 /nobreak >nul
cls
echo [92mDownloader Done![0m
echo.
echo [36mMods downloaded: !modsDownloaded! [0m
echo [33mMods skipped: !modsSkipped! [0m
echo.
echo closing in 2s
timeout 1 /nobreak >nul
cls
echo [92mDownloader Done![0m
echo.
echo [36mMods downloaded: !modsDownloaded! [0m
echo [33mMods skipped: !modsSkipped! [0m
echo.
echo closing in 1s
timeout 1 /nobreak >nul
EXIT /B 0
