@echo off
echo Updating qiiwexc...
taskkill /im qiiwexc.exe
ping -n 2 127.0.0.1 >nul
del qiiwexc.exe
ren qiiwexc.tmp qiiwexc.exe
start qiiwexc.exe
del "%~f0"
