@echo off

set lang=Russian

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

tasklist /FI "IMAGENAME eq ClassicStart.exe" 2> nul | find /I /N "ClassicStart.exe"> nul
if "%ERRORLEVEL%"=="0" (
  cls
  echo StartMenu 8 must not be running! Close it manually or it will be forced to close automatically.
  pause
  taskkill /im ClassicStart.exe /f> nul
)

cd "%userprofile%\AppData\LocalLow\IObit\StartMenu 8"

(echo [Main])> Main.ini
(echo DeactivateFullScreen=1)>> Main.ini
(echo DownHotCorners=1)>> Main.ini
(echo FontColor_Left=0)>> Main.ini
(echo FontColor_Right=16777215)>> Main.ini
(echo FontSize=0)>> Main.ini
(echo Frequently_Sytle=1)>> Main.ini
(echo Highlightnewly=1)>> Main.ini
(echo HotSidebar=1)>> Main.ini
(echo IconSize=1)>> Main.ini
(echo Intall=1)>> Main.ini
(echo Language=%lang%)>> Main.ini
(echo LeftoOpenMetro=0)>> Main.ini
(echo MenuStyleTransparency=255)>> Main.ini
(echo NotShowFrequentlyUsedPrograms=0)>> Main.ini
(echo NotShowNews=1)>> Main.ini
(echo OpenMetroStyle=1)>> Main.ini
(echo program_background_color_changes_with_system=1)>> Main.ini
(echo recent_items_Number=10)>> Main.ini
(echo recentprogramNumber=10)>> Main.ini
(echo ShudownIndex=6)>> Main.ini
(echo SkinName=Win8start)>> Main.ini
(echo SkipStartScreen=1)>> Main.ini
(echo SkipUACStartMenu=1)>> Main.ini
(echo SkipWelcomScreen=0)>> Main.ini
(echo Startup=1)>> Main.ini
(echo UpHotCorners=1)>> Main.ini
(echo Use_System_Picture=1)>> Main.ini
(echo UserAvatar=)>> Main.ini
(echo win8Style=0)>> Main.ini
(echo Windows_Style=win8)>> Main.ini
(echo WinkeyoOpenMetro=0)>> Main.ini
(echo [Menu])>> Main.ini
(echo AdministrativeTools=0)>> Main.ini
(echo Computer=1)>> Main.ini
(echo ConnectTo=0)>> Main.ini
(echo ControlPanel=1)>> Main.ini
(echo DefaultPrograms=0)>> Main.ini
(echo DevicesandPrinters=0)>> Main.ini
(echo Documenuts=1)>> Main.ini
(echo Downloads=1)>> Main.ini
(echo Favorites=0)>> Main.ini
(echo Games=1)>> Main.ini
(echo HelpandSupport=0)>> Main.ini
(echo Homegroup=0)>> Main.ini
(echo MetroApps=2)>> Main.ini
(echo Music=1)>> Main.ini
(echo Network=0)>> Main.ini
(echo PCSetting=1)>> Main.ini
(echo PersonalFolder=1)>> Main.ini
(echo Pictures=1)>> Main.ini
(echo RecentItems=0)>> Main.ini
(echo RecordedTV=0)>> Main.ini
(echo Run...=1)>> Main.ini
(echo Videos=0)>> Main.ini
(echo Windows8FAQ=0)>> Main.ini
