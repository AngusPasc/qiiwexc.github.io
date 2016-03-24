@echo off

echo Compiling . . .

set "old_date="
for /F " delims=" %%i in (version) do if not defined old_date set "old_date=%%i"

set "today="
for /F "skip=1 delims=" %%i in (version) do if not defined today set /a "today=%%i"

set "total="
for /F "skip=2 delims=" %%i in (version) do if not defined total set /a "total=%%i"

set /a total = %total% + 1

if %date:~6,2%.%date:~3,2%.%date:~0,2% == %old_date% (
    set /a today = %today% + 1
) else (
    set /a today = 0
)

echo %date:~6,2%.%date:~3,2%.%date:~0,2%> version
echo %today% >> version
echo %total% >> version

"%ProgramFiles(x86)%\AutoIt3\Beta\Aut2Exe\Aut2exe.exe" /in %UserProfile%/Desktop/qiiwexc.github.io/dev/qiiwexc.au3 /out %UserProfile%/Desktop/qiiwexc.github.io/qiiwexc_(x86).exe /icon %UserProfile%/Desktop/qiiwexc.github.io/favicon.ico /comp 4 /productname qiiwexc /originalfilename qiiwexc.exe /productversion %total% /fileversion %date:~6,2%.%date:~3,2%.%date:~0,2%.%today%
"%ProgramFiles(x86)%\AutoIt3\Beta\Aut2Exe\Aut2exe_x64.exe" /in %UserProfile%/Desktop/qiiwexc.github.io/dev/qiiwexc.au3 /out %UserProfile%/Desktop/qiiwexc.github.io/qiiwexc_(x64).exe /icon %UserProfile%/Desktop/qiiwexc.github.io/favicon.ico /comp 4 /productname qiiwexc /originalfilename qiiwexc.exe /productversion %total% /fileversion %date:~6,2%.%date:~3,2%.%date:~0,2%.%today%
