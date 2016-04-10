@echo off

set lang=1062

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

tasklist /FI "IMAGENAME eq CCleaner.exe" 2> nul | find /I /N "CCleaner.exe"> nul
if "%ERRORLEVEL%"=="0" (
  cls
  echo CCleaner must not be running! Close it manually or it will be forced to close automatically.
  pause
  taskkill /im CCleaner.exe /f> nul
)

tasklist /FI "IMAGENAME eq CCleaner64.exe" 2> nul | find /I /N "CCleaner64.exe"> nul
if "%ERRORLEVEL%"=="0" (
  cls
  echo CCleaner must not be running! Close it manually or it will be forced to close automatically.
  pause
  taskkill /im CCleaner64.exe /f> nul
)

if not exist %ProgramFiles%\CCleaner\ mkdir %ProgramFiles%\CCleaner\

cd %ProgramFiles%\CCleaner\

echo [Options] > CCleaner.ini
echo (App)Adobe Air=True >> CCleaner.ini
echo (App)Adobe Flash Player=True >> CCleaner.ini
echo (App)Autocomplete Form History=True >> CCleaner.ini
echo (App)Avast! Antivirus=True >> CCleaner.ini
echo (App)Chkdsk File Fragments=True >> CCleaner.ini
echo (App)Clipboard=True >> CCleaner.ini
echo (App)Cookies=True >> CCleaner.ini
echo (App)Custom Folders=True >> CCleaner.ini
echo (App)Delete Index.dat files=True >> CCleaner.ini
echo (App)Desktop Shortcuts=True >> CCleaner.ini
echo (App)DNS Cache=True >> CCleaner.ini
echo (App)Empty Recycle Bin=True >> CCleaner.ini
echo (App)Environment Path=True >> CCleaner.ini
echo (App)Font Cache=True >> CCleaner.ini
echo (App)Game Explorer=True >> CCleaner.ini
echo (App)Google Chrome - Compact Databases=True >> CCleaner.ini
echo (App)Google Chrome - Cookies=True >> CCleaner.ini
echo (App)Google Chrome - Download History=True >> CCleaner.ini
echo (App)Google Chrome - Internet Cache=True >> CCleaner.ini
echo (App)Google Chrome - Internet History=True >> CCleaner.ini
echo (App)Google Chrome - Saved Form Information=True >> CCleaner.ini
echo (App)Google Chrome - Saved Passwords=True >> CCleaner.ini
echo (App)Google Chrome - Session=True >> CCleaner.ini
echo (App)History=True >> CCleaner.ini
echo (App)Hotfix Uninstallers=True >> CCleaner.ini
echo (App)IIS Log Files=True >> CCleaner.ini
echo (App)Java=True >> CCleaner.ini
echo (App)Last Download Location=True >> CCleaner.ini
echo (App)Macromedia Shockwave 10=True >> CCleaner.ini
echo (App)Macromedia Shockwave 11=True >> CCleaner.ini
echo (App)Media Player Classic=True >> CCleaner.ini
echo (App)Memory Dumps=True >> CCleaner.ini
echo (App)Menu Order Cache=True >> CCleaner.ini
echo (App)Microsoft Edge - Saved Form Information=True >> CCleaner.ini
echo (App)Microsoft Edge - Saved Passwords=True >> CCleaner.ini
echo (App)Microsoft Silverlight=True >> CCleaner.ini
echo (App)Mozilla - Compact Databases=True >> CCleaner.ini
echo (App)Mozilla - Saved Form Information=True >> CCleaner.ini
echo (App)Mozilla - Saved Passwords=True >> CCleaner.ini
echo (App)Mozilla - Site Preferences=True >> CCleaner.ini
echo (App)MS Management Console=True >> CCleaner.ini
echo (App)MS Office Picture Manager=True >> CCleaner.ini
echo (App)MS Paint=True >> CCleaner.ini
echo (App)MS Search=True >> CCleaner.ini
echo (App)Network Passwords=True >> CCleaner.ini
echo (App)Notepad++=True >> CCleaner.ini
echo (App)Office 2007=True >> CCleaner.ini
echo (App)Office 2010=True >> CCleaner.ini
echo (App)Office 2016=True >> CCleaner.ini
echo (App)Old Prefetch data=True >> CCleaner.ini
echo (App)Old Windows Installation=True >> CCleaner.ini
echo (App)Opera - Compact Databases=True >> CCleaner.ini
echo (App)Opera - Saved Form Information=True >> CCleaner.ini
echo (App)Opera - Saved Passwords=True >> CCleaner.ini
echo (App)Other Explorer MRUs=True >> CCleaner.ini
echo (App)Recent Documents=True >> CCleaner.ini
echo (App)Recently Typed URLs=True >> CCleaner.ini
echo (App)RegEdit=True >> CCleaner.ini
echo (App)Run (in Start Menu)=True >> CCleaner.ini
echo (App)Saved Passwords=True >> CCleaner.ini
echo (App)Skype=True >> CCleaner.ini
echo (App)Start Menu Shortcuts=True >> CCleaner.ini
echo (App)Taskbar Jump Lists=True >> CCleaner.ini
echo (App)Temporary Files=True >> CCleaner.ini
echo (App)Temporary Internet Files=True >> CCleaner.ini
echo (App)Thumbnail Cache=True >> CCleaner.ini
echo (App)Tray Notifications Cache=True >> CCleaner.ini
echo (App)User Assist History=True >> CCleaner.ini
echo (App)uTorrent=True >> CCleaner.ini
echo (App)Window Size/Location Cache=True >> CCleaner.ini
echo (App)Windows Defender=True >> CCleaner.ini
echo (App)Windows Error Reporting=True >> CCleaner.ini
echo (App)Windows Event Logs=True >> CCleaner.ini
echo (App)Windows Log Files=True >> CCleaner.ini
echo (App)Windows Media Center=True >> CCleaner.ini
echo (App)Windows Media Player=True >> CCleaner.ini
echo (App)WinRAR=True >> CCleaner.ini
echo (App)Wipe Free Space=False >> CCleaner.ini
echo AnalyzerTypes=1^|1^|1^|1^|1^|1^|1 >> CCleaner.ini
echo BackupPrompt=0 >> CCleaner.ini
echo CheckTrialOffer=0 >> CCleaner.ini
echo DelayTemp=0 >> CCleaner.ini
echo HideWarnings=1 >> CCleaner.ini
echo IgnoreEmptyFiles=0 >> CCleaner.ini
echo IgnoreFileSizeUnder=0 >> CCleaner.ini
echo IgnoreHiddenFiles=0 >> CCleaner.ini
echo IgnoreReadOnlyFiles=0 >> CCleaner.ini
echo IgnoreSystemFiles=0 >> CCleaner.ini
echo Include1=PATH^|%userprofile%\AppData\Local\Temp^|*.*^|REMOVESELF >> CCleaner.ini
echo Include2=PATH^|C:\Windows\Temp\^|*.*^|REMOVESELF >> CCleaner.ini
echo Include3=PATH^|C:\Windows\SoftwareDistribution\Download\^|*.*^|REMOVESELF >> CCleaner.ini
echo Include4=PATH^|C:\^|desktop.ini^|REMOVESELF >> CCleaner.ini
echo Include5=PATH^|C:\^|Thumbs.db^|REMOVESELF >> CCleaner.ini
echo Include6=PATH^|D:\^|desktop.ini^|REMOVESELF >> CCleaner.ini
echo Include7=PATH^|D:\^|Thumbs.db^|REMOVESELF >> CCleaner.ini
echo Include8=PATH^|E:\^|desktop.ini^|REMOVESELF >> CCleaner.ini
echo Include9=PATH^|E:\^|Thumbs.db^|REMOVESELF >> CCleaner.ini
echo Include10=PATH^|F:\^|desktop.ini^|REMOVESELF >> CCleaner.ini
echo Include11=PATH^|F:\^|Thumbs.db^|REMOVESELF >> CCleaner.ini
echo Language=%lang% >> CCleaner.ini
echo MatchByContent=1 >> CCleaner.ini
echo MatchBySize=1 >> CCleaner.ini
echo Monitoring=0 >> CCleaner.ini
echo NewVersion= >> CCleaner.ini
echo NewVersionNotification=1 >> CCleaner.ini
echo RunICS=0 >> CCleaner.ini
echo SecureDeleteType=0 >> CCleaner.ini
echo ShowCleanWarning=False >> CCleaner.ini
echo SplitterPositionCleaner=291 >> CCleaner.ini
echo SplitterPositionRegistry=218 >> CCleaner.ini
echo SystemAnalyzerDrives=C:\ >> CCleaner.ini
echo SystemMonitoring=0 >> CCleaner.ini
echo UpdateCheck=1 >> CCleaner.ini
echo WINDOW_HEIGHT=600 >> CCleaner.ini
echo WINDOW_LEFT=0 >> CCleaner.ini
echo WINDOW_MAX=1 >> CCleaner.ini
echo WINDOW_TOP=0 >> CCleaner.ini
echo WINDOW_WIDTH=800 >> CCleaner.ini
echo WipeFreeSpaceDrives= >> CCleaner.ini
echo WipeMFTFreeSpace=0 >> CCleaner.ini
