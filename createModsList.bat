@echo off
dir /b /a-d | findstr /v createModsList.bat |  findstr /v mods |  findstr /v updateMods.bat > mods
echo File: mods created
timeout /t 5 /nobreak >nul