@echo off

set lang1=ru
set lang2=lv
set lang3=en-US

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

tasklist /FI "IMAGENAME eq chrome.exe" 2> nul | find /I /N "chrome.exe"> nul
if "%ERRORLEVEL%"=="0" (
  cls
  echo Google Chrome must not be running! Close it manually or it will be forced to close automatically.
  pause
  taskkill /im chrome.exe /f> nul
)

for /f "skip=1" %%v in ('wmic os get version') do if not defined version set version=%%v
for /f "delims=. tokens=1-2" %%a in ("%version%") do (set version=%%a)

if %version% gtr 5 (
  set targetA="%userprofile%\AppData\Local\Google\Chrome\User Data"
  set targetB="%userprofile%\AppData\Local\Google\Chrome\User Data\Default"
) else (
  set targetA="%userprofile%\Local Settings\Google\Chrome\User Data"
  set targetB="%userprofile%\Local Settings\Google\Chrome\User Data\Default"
)

if not exist %targetA% mkdir %targetA%
if not exist %targetB% mkdir %targetB%

cd %targetA%

echo {> "Local State"
echo   "intl": {>> "Local State"
echo     "app_locale": "%lang1%">> "Local State"
echo   },>> "Local State"
echo   "profile": {>> "Local State"
echo     "add_person_enabled": false,>> "Local State"
echo     "browser_guest_enabled": false>> "Local State"
echo   }>> "Local State"
echo }>> "Local State"

cd %targetB%

echo {> Preferences
echo   "bookmark_bar": {>> Preferences
echo     "show_apps_shortcut": false>> Preferences
echo   },>> Preferences
echo   "browser": {>> Preferences
echo     "check_default_browser": true,>> Preferences
echo     "clear_data": {>> Preferences
echo       "content_licenses": true,>> Preferences
echo       "form_data": true,>> Preferences
echo       "hosted_apps_data": true,>> Preferences
echo       "passwords": true,>> Preferences
(echo       "time_period": 4)>> Preferences
echo     },>> Preferences
echo     "clear_lso_data_enabled": true>> Preferences
echo   },>> Preferences
echo   "extensions": {>> Preferences
echo     "ui": {>> Preferences
echo       "developer_mode": true>> Preferences
echo     }>> Preferences
echo   },>> Preferences
echo   "intl": {>> Preferences
echo     "accept_languages": "%lang1%,%lang2%,%lang3%,en">> Preferences
echo   },>> Preferences
echo   "safebrowsing": {>> Preferences
echo     "extended_reporting_enabled": true>> Preferences
echo   },>> Preferences
echo   "spellcheck": {>> Preferences
echo     "dictionaries": [>> Preferences
echo       "%lang1%",>> Preferences
echo       "%lang2%",>> Preferences
echo       "%lang3%">> Preferences
echo     ],>> Preferences
echo     "use_spelling_service": true>> Preferences
echo   }>> Preferences
echo }>> Preferences
