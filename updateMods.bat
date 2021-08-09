@echo off
setlocal enabledelayedexpansion
cls
title MineColonies Mod Downloader
echo by GreenMaskEnergy [90mversion 2.4[0m 
echo.
echo.
echo - download missing mods
echo - update outdated mods
echo - remove unused mods
echo in the same directory as this is run from!
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
    pause>nul|set/p =[36mpress any key to start[0m download,update,remove mods.
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
echo.TimeStamp     Progress     Status      Modname >> "%log%"
echo --------------------------------------------------------------------------------------------- >> "%log%"
echo.[%time:~0,-3%]       /      ✅ Download    ModListFile (mods) >> "%log%"
bitsadmin.exe /transfer "" /priority FOREGROUND https://onehit.eu/MC_ModLists/MineColonies/mods "%RawPath%/mods"
echo. >> "%log%"
set "cmd=findstr /R /N "^^" "%RawPath%\mods" | find /C ":""
for /f %%a in ('!cmd!') do set ModCount=%%a
set "space=DEF"
set "modsSkipped=0"
set "modsDownloaded=0"
set "modsUpdated=0"
set "modsRemoved=0"
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


    Set "fileNameCheck=%%A"
    for /f "delims=|" %%S in ("!fileNameCheck:-=|!") do (
        REM Echo [46m%%S[0m
        if exist "%~dp0%%S*.jar" (
            REM echo [32mFound %%S "%~dp0%%S*.jar"[0m
            if exist "%~dp0%%A" (
                echo [42mUp to Date[0m [32m%%A[0m
                set /a modsSkipped=!modsSkipped!+1
                echo [!TIME:~0,-3!]   !space!!progress! / %ModCount%   ❌ Skipped     %%A >> "%log%"
            ) else (
                for /R "%RawPath%" %%j in (*.jar) do (
                    echo %%~nj |find "%%S" >nul
                    if not errorlevel 1 (
                        echo [41mDifferent Version[0m [31m%%j [0m[90mNewer version[0m [32m%%A[0m 
                        DEL "%%j"
                        set /a modsUpdated=!modsUpdated!+1
                        echo [!TIME:~0,-3!]   !space!!progress! / %ModCount%   🔼 Updated     %%A >> "%log%"
                        bitsadmin.exe /transfer "Mod (!progress! / !ModCount!): %%A"  /priority FOREGROUND https://github.com/greenmaskenergy/MineColonies/raw/master/%%A "%RawPath%/%%A"
                    )
                    
                )
                
            )
        ) else (
            set /a modsDownloaded=!modsDownloaded!+1
            echo [!TIME:~0,-3!]   !space!!progress! / %ModCount%   ✅ Download    %%A >> "%log%"
            echo [31mMissing %%S[0m
            bitsadmin.exe /transfer "Mod (!progress! / !ModCount!): %%A"  /priority FOREGROUND https://github.com/greenmaskenergy/MineColonies/raw/master/%%A "%RawPath%/%%A"
        )
    )
)
echo. >> "%log%"
REM removing mods that are present in folder but not modpack
for /R "%RawPath%" %%f in (*.jar) do (
    >nul find "%%~nf" "%RawPath%\mods" && (
  REM echo %%~nf was found.
) || (
  set /a modsRemoved=!modsRemoved!+1
  echo [!TIME:~0,-3!]       /      🗑️ Removed     %%~nf >> "%log%"
  DEL "%%f"
)
)


echo --------------------------------------------------------------------------------------------- >> "%log%"
echo.Mods ✅ downloaded: !modsDownloaded! >> "%log%"
echo.Mods 🔼 Updated:    !modsUpdated! >> "%log%"
echo.Mods ❌ skipped:    !modsSkipped! >> "%log%"
echo.Mods 🗑️ Removed:    !modsRemoved! >> "%log%"
echo [92mDownloader Done![0m
echo.
echo [36mMods downloaded: !modsDownloaded! [0m
echo [104mMods updated:  !modsUpdated! [0m
echo [33mMods skipped: !modsSkipped! [0m
echo [101mMods removed: !modsRemoved! [0m
timeout 5 /nobreak >nul
EXIT /B 0
