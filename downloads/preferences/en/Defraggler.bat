@echo off

set lang=1033

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

tasklist /FI "IMAGENAME eq Defraggler.exe" 2> nul | find /I /N "Defraggler.exe"> nul
if "%ERRORLEVEL%"=="0" (
  cls
  echo Defraggler must not be running! Close it manually or it will be forced to close automatically.
  pause
  taskkill /im Defraggler.exe /f> nul
)

tasklist /FI "IMAGENAME eq Defraggler64.exe" 2> nul | find /I /N "Defraggler64.exe"> nul
if "%ERRORLEVEL%"=="0" (
  cls
  echo Defraggler must not be running! Close it manually or it will be forced to close automatically.
  pause
  taskkill /im Defraggler64.exe /f> nul
)

if not exist %ProgramFiles%\Defraggler\ mkdir %ProgramFiles%\Defraggler\

cd %ProgramFiles%\Defraggler\

echo [Software\Piriform\Defraggler] > Defraggler.ini
echo AnalyzeContextString=^&Check Fragmentation >> Defraggler.ini
echo CacheFileCollectionAfterDriveSwitch=1 >> Defraggler.ini
echo CelsiusTemperatureFormat=1 >> Defraggler.ini
echo CleanupDriveBeforeDefrag=1 >> Defraggler.ini
echo ColorsMode=1 >> Defraggler.ini
echo DefragContextString=^&Defragment >> Defraggler.ini
echo DefragFreeSpaceMoveLargeFiles=1 >> Defraggler.ini
echo DisableShellExtension=0 >> Defraggler.ini
echo DisplayEjectedVolumes=1 >> Defraggler.ini
echo DisplayRemovableVolumes=1 >> Defraggler.ini
echo DisplaySSDVolumes=1 >> Defraggler.ini
echo DisplayUnmountedVolumes=1 >> Defraggler.ini
echo DriveMapColors=0:8046565;1:12681634;2:65535;3:49152;4:255;5:16711680;6:6517215;7:8491005;8:12028509;9:14002309;10:16777215;11:4605510;12:16777215; >> Defraggler.ini
echo DriveMapDrawingMode=1 >> Defraggler.ini
echo DriveMapMinBlockHeight=10 >> Defraggler.ini
echo DriveMapMinBlockWidth=10 >> Defraggler.ini
echo DriveMapMode=0 >> Defraggler.ini
echo DriveMapSettingsMode=0 >> Defraggler.ini
echo EnableNativeDefrag=0 >> Defraggler.ini
echo filelist_columns=2;0;(0;445);(1;28);(2;70);(3;81);(4;480);(5;100);(6;127); >> Defraggler.ini
echo Language=%lang% >> Defraggler.ini
echo LargeFilesCategories=Movie files;1 >> Defraggler.ini
echo LargeFilesExtensions=*.m2ts >> Defraggler.ini
echo MainWindowBottomSplitterProportionalPos=2907 >> Defraggler.ini
echo MainWindowTopSplitterProportionalPos=1040 >> Defraggler.ini
echo MinimizeToTray=0 >> Defraggler.ini
echo MinLargeFileSize=200 >> Defraggler.ini
echo MoveLargeFilesToEndOfDrive=0 >> Defraggler.ini
echo MoveOnlySelectedLargeFileCategories=0 >> Defraggler.ini
echo NativeMode=1 >> Defraggler.ini
echo NewVersion= >> Defraggler.ini
echo PreviousDefragPath= >> Defraggler.ini
echo Priority=32801 >> Defraggler.ini
echo QDMaxFileSize=0;100 >> Defraggler.ini
echo QDMaxFragmentCount=0;2 >> Defraggler.ini
echo QDMinFileSize=0;0 >> Defraggler.ini
echo QDMinFragmentSize=1;50 >> Defraggler.ini
echo QDUseCustomParameters=0 >> Defraggler.ini
echo ReplaceWindowsDefrag=0 >> Defraggler.ini
echo ShowCleanupPrompt=1 >> Defraggler.ini
echo ShowFragmentedFolderEntries=1 >> Defraggler.ini
echo ShowOptimizeZeroFillingWarning=0 >> Defraggler.ini
echo StopVssWhenDefrag=1 >> Defraggler.ini
echo UpdateBackground=0 >> Defraggler.ini
echo UpdateCheck=1 >> Defraggler.ini
echo UpdateFrequency=10 >> Defraggler.ini
echo WasRunManualSilentUpdate=0 >> Defraggler.ini
echo window_flags=2 >> Defraggler.ini
echo window_height=733 >> Defraggler.ini
echo window_left=-6 >> Defraggler.ini
echo window_max=3 >> Defraggler.ini
echo window_top=1 >> Defraggler.ini
echo window_width=1378 >> Defraggler.ini
