@echo off

set lang=en

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

tasklist /FI "IMAGENAME eq qbittorrent.exe" 2> nul | find /I /N "qbittorrent.exe"> nul
if "%ERRORLEVEL%"=="0" (
  cls
  echo qBittorrent must not be running! Close it manually or it will be forced to close automatically.
  pause
  taskkill /im qbittorrent.exe /f> nul
)

for /f "skip=1" %%v in ('wmic os get version') do if not defined version set version=%%v
for /f "delims=. tokens=1-2" %%a in ("%version%") do (set version=%%a)

if %version% gtr 5 (
  set target=%userprofile%\AppData\Roaming\qBittorrent
) else (
  set target="%userprofile%\Application Data\qBittorrent"
)

if not exist %target% mkdir %target%

cd %target%

echo [LegalNotice]> qBittorrent.ini
echo Accepted=true>> qBittorrent.ini
echo [MainWindow]>> qBittorrent.ini
echo geometry="@ByteArray(\x1\xd9\xd0\xcb\0\x2\0\0\xff\xff\xff\xf8\xff\xff\xff\xf8\0\0\x5]\0\0\x2\xdf\0\0\0\xe2\0\0\0^\0\0\x4s\0\0\x2\x90\0\0\0\0\x2\0\0\0\x5V)">> qBittorrent.ini
echo qt5\vsplitterState=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\0v\0\0\x4\xc9\x1\xff\xff\xff\xff\x1\0\0\0\x1\0)>> qBittorrent.ini
echo [Preferences]>> qBittorrent.ini
echo Advanced\AnnounceToAllTrackers=true>> qBittorrent.ini
echo Advanced\confirmTorrentDeletion=true>> qBittorrent.ini
echo Advanced\confirmTorrentRecheck=true>> qBittorrent.ini
echo Advanced\IgnoreLimitsLAN=true>> qBittorrent.ini
echo Advanced\LtTrackerExchange=true>> qBittorrent.ini
echo Advanced\RecheckOnCompletion=true>> qBittorrent.ini
echo Advanced\trackerEnabled=true>> qBittorrent.ini
echo Advanced\updateCheck=true>> qBittorrent.ini
echo Bittorrent\AddTrackers=false>> qBittorrent.ini
echo Bittorrent\DHT=true>> qBittorrent.ini
echo Bittorrent\LSD=true>> qBittorrent.ini
echo Bittorrent\MaxConnecsPerTorrent=-1>> qBittorrent.ini
echo Bittorrent\MaxUploads=-1>> qBittorrent.ini
echo Bittorrent\MaxUploadsPerTorrent=-1>> qBittorrent.ini
echo Bittorrent\PeX=true>> qBittorrent.ini
echo Bittorrent\uTP=true>> qBittorrent.ini
echo Bittorrent\uTP_rate_limited=false>> qBittorrent.ini
echo Connection\GlobalDLLimitAlt=-1>> qBittorrent.ini
echo Connection\GlobalUPLimitAlt=-1>> qBittorrent.ini
echo Connection\MaxHalfOpenConnec=-1>> qBittorrent.ini
echo Connection\ResolvePeerCountries=true>> qBittorrent.ini
echo Connection\ResolvePeerHostNames=true>> qBittorrent.ini
echo Connection\UPnP=true>> qBittorrent.ini
echo Downloads\AppendLabel=true>> qBittorrent.ini
(echo Downloads\DblClOnTorDl=0)>> qBittorrent.ini
(echo Downloads\DblClOnTorFn=1)>> qBittorrent.ini
echo Downloads\NewAdditionDialog=true>> qBittorrent.ini
echo Downloads\NewAdditionDialogFront=true>> qBittorrent.ini
echo Downloads\PreAllocation=true>> qBittorrent.ini
(echo Downloads\SaveResumeDataInterval=3)>> qBittorrent.ini
echo Downloads\StartInPause=false>> qBittorrent.ini
echo Downloads\UseIncompleteExtension=true>> qBittorrent.ini
echo ExecutionLog\enabled=false>> qBittorrent.ini
echo General\AlternatingRowColors=true>> qBittorrent.ini
echo General\CloseToTray=false>> qBittorrent.ini
echo General\ExitConfirm=true>> qBittorrent.ini
echo General\Locale=%lang%>> qBittorrent.ini
echo General\MinimizeToTray=false>> qBittorrent.ini
echo General\NoSplashScreen=true>> qBittorrent.ini
echo General\ProgramNotification=true>> qBittorrent.ini
echo General\PreventFromSuspend=true>> qBittorrent.ini
echo General\RefreshInterval=1000>> qBittorrent.ini
echo General\SpeedInTitleBar=true>> qBittorrent.ini
echo General\StartMinimized=false>> qBittorrent.ini
echo General\SystrayEnabled=false>> qBittorrent.ini
echo Queueing\IgnoreSlowTorrents=true>> qBittorrent.ini
echo Queueing\QueueingEnabled=true>> qBittorrent.ini
echo State\hSplitterSizes=115, 637>> qBittorrent.ini
echo State\pos=@Point(286 49)>> qBittorrent.ini
echo State\size=@Size(779 591)>> qBittorrent.ini
echo [SpeedWidget]>> qBittorrent.ini
echo graph_enable_0=true>> qBittorrent.ini
echo graph_enable_1=true>> qBittorrent.ini
echo graph_enable_2=true>> qBittorrent.ini
echo graph_enable_3=true>> qBittorrent.ini
echo graph_enable_4=true>> qBittorrent.ini
echo graph_enable_5=true>> qBittorrent.ini
echo graph_enable_6=true>> qBittorrent.ini
echo graph_enable_7=true>> qBittorrent.ini
echo graph_enable_8=true>> qBittorrent.ini
echo graph_enable_9=true>> qBittorrent.ini
(echo period=0)>> qBittorrent.ini
echo [TorrentProperties]>> qBittorrent.ini
(echo CurrentTab=5)>> qBittorrent.ini
echo SplitterSizes="71,542">> qBittorrent.ini
echo Visible=true>> qBittorrent.ini
