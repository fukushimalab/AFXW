@echo off

setlocal enabledelayedexpansion

SET /a counter=0

for /f "usebackq delims=" %%a in (%1) do (
if "!counter!"=="%2" goto exit
echo %%a
set /a counter+=1
)

:exit