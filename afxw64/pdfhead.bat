@echo off
setlocal
pushd "%~dp0"
xdoc2txt.exe %1>stdout.txt
head.bat stdout.txt %2
popd