@echo off

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
  echo Requesting administrative privileges...
  goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "%~s0", "%params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"

tasklist /FI "IMAGENAME eq vlc.exe" 2> nul | find /I /N "vlc.exe"> nul
if "%ERRORLEVEL%"=="0" (
  cls
  echo VLC Media Player must not be running! Close it manually or it will be forced to close automatically.
  pause
  taskkill /im vlc.exe /f> nul
)

for /f "skip=1" %%v in ('wmic os get version') do if not defined version set version=%%v
for /f "delims=. tokens=1-2" %%a in ("%version%") do (set version=%%a)

if %version% gtr 5 (
  set target=%userprofile%\AppData\Roaming\vlc
) else (
  set target="%userprofile%\Application Data\vlc"
)

if not exist %target% mkdir %target%

cd %target%

(echo [qt4])> vlcrc
(echo qt-system-tray=0)>> vlcrc
(echo qt-updates-days=1)>> vlcrc
(echo qt-privacy-ask=0)>> vlcrc
(echo [core])>> vlcrc
(echo video-title-show=0)>> vlcrc
(echo osd=0)>> vlcrc
(echo metadata-network-access=1)>> vlcrc
