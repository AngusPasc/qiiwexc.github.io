#comments-start

TODO: updates, zip, search, control panel buttons and common actions, utilities, preferences, statistics, configuration file, registry, icon

#comments-end

#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ProgressConstants.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <Inet.au3>
#include <InetConstants.au3>
#include <FileConstants.au3>

Global Const $VERSION = "16.4.10"
Global $Width, $Height, $SMART_Text, $Admin_Text
Global $Window, $Log, $Start, $Stop, $Progress, $Input, $Search, $Internet, $Update, $Admin, $Parse, $SMART
Global $OSArch, $OSLang, $OSVersion, $IP, $File, $New, $A_Version, $B_Version

$Width = 500
$Height = 500

$SMART_Text = "S.M.A.R.T.:" & _
@CRLF & "" & _
@CRLF & "Value: higher is better" & _
@CRLF & "Threshold: must be higher than Value" & _
@CRLF & "Worst: the lowest value ever registered" & _
@CRLF & "Raw: current value in hex" & _
@CRLF & "Type: attribute type:" & _
@CRLF & "  - PR: Performance-related" & _
@CRLF & "  - ER: Error rate" & _
@CRLF & "  - EC: Events count" & _
@CRLF & "  - SP: Self-preserve"

$Admin_Text = "@echo off" & _
@CRLF & '>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"' & _
@CRLF & "if '%errorlevel%' NEQ '0' (" & _
@CRLF & "echo Requesting administrative privileges..." & _
@CRLF & "goto UACPrompt" & _
@CRLF & ") else ( goto gotAdmin )" & _
@CRLF & ":UACPrompt" & _
@CRLF & 'echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"' & _
@CRLF & 'set params = %*:"=""' & _
@CRLF & 'echo UAC.ShellExecute "%~s0", "%params%", "", "runas", 1 >> "%temp%\getadmin.vbs"' & _
@CRLF & '"%temp%\getadmin.vbs"' & _
@CRLF & "exit /B" & _
@CRLF & ":gotAdmin" & _
@CRLF & 'if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )' & _
@CRLF & 'pushd "%CD%"' & _
@CRLF & 'CD /D "%~dp0"' & _
@CRLF & "::----PLACE----YOUR----CODE----BELOW----" & _
@CRLF & "" & @CRLF & ""

$Window   = GUICreate("qiiwexc v" & $VERSION & " (DEV)", $Width, $Height)
$Log      = GUICtrlCreateEdit(">>> Loading . . .", 0, $Height-100, $Width, 100, 0x00201884)
$Start    = GUICtrlCreateButton("Start", $Width-60, $Height-131, 60, 32, 0x0001)
$Stop     = GUICtrlCreateButton("Stop", $Width-119, $Height-131, 60, 32, $WS_DISABLED)
$Progress = GUICtrlCreateProgress(0, $Height-130, $Width-119, 30, 0x01) ;0x00000008
$Input    = GUICtrlCreateInput("Search dev.id for drivers...", 0, 0, $Width-60, 22)
$Search   = GUICtrlCreateButton("Search", $Width-60, 0, 60, 23)
$Update   = GUICtrlCreateButton("Check for updates", $Width-100, 25, 100, 23)
$Internet = GUICtrlCreateButton("Get IP address", $Width-80, 50, 80, 23)
$Admin    = GUICtrlCreateButton("Admin Batch", $Width-80, 75, 80, 23)
$Parse    = GUICtrlCreateButton("Parse SFC log", $Width-80, 100, 80, 23)
$SMART    = GUICtrlCreateLabel($SMART_Text, 10, 25)

GUISetState(@SW_SHOW, $Window)

Logger("qiiwexc v" & $VERSION & " started")

Select
    Case @OSArch = "X64"
        $OSArch = "64-bit"
    Case @OSArch = "X32"
        $OSArch = "32-bit"
EndSelect

Select
    Case @OSLang = "0409"
        $OSLang = "English"
    Case @OSLang = "0419"
        $OSLang = "Russian"
    Case @OSLang = "0426"
        $OSLang = "Latvian"
    Case Else
        $OSLang = "Other"
EndSelect

Select
    Case @OSVersion = "WIN_10"
        $OSVersion = "Windows 10"
    Case @OSVersion = "WIN_81"
        $OSVersion = "Windows 8.1"
    Case @OSVersion = "WIN_8"
        $OSVersion = "Windows 8"
    Case @OSVersion = "WIN_7"
        $OSVersion = "Windows 7"
    Case @OSVersion = "WIN_VISTA"
        $OSVersion = "Windows Vista"
    Case @OSVersion = "WIN_XP"
        $OSVersion = "Windows XP"
    Case @OSVersion = "WIN_XPe"
        $OSVersion = "Windows XP Embeded"
    Case @OSVersion = "WIN_2012R2"
        $OSVersion = "Windows Server 2012 R2"
    Case @OSVersion = "WIN_2012"
        $OSVersion = "Windows Server 2012"
    Case @OSVersion = "WIN_2008R2"
        $OSVersion = "Windows Server 2008 R2"
    Case @OSVersion = "WIN_2008"
        $OSVersion = "Windows Server 2008"
    Case @OSVersion = "WIN_2003"
        $OSVersion = "Windows Server 2003"
    Case Else
        $OSVersion = "Unknown"
EndSelect

Logger("Running on " & $OSVersion & " " & @OSServicePack & " " & $OSArch & " Build " & @OSBuild & " " & $OSLang)
Update()

While 1
    Switch GUIGetMsg()

        Case $GUI_EVENT_CLOSE, $Stop
            GUIDelete($Window)
            ExitLoop

        Case $Admin
            Admin()

        Case $Internet
            Internet()

        Case $Parse
            Parse()

        Case $Search
            Search()

        Case $Start
            Start()

        Case $Update
            Update()

    EndSwitch
WEnd

Func Logger($Message)
    _GUICtrlEdit_AppendText($Log, @CRLF & @MDAY & "." & @MON & "." & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC & " - " & $Message)
EndFunc

Func Title($Title)
    WinSetTitle($Window, "", $Title & " - " & "qiiwexc v" & $VERSION)
EndFunc

Func Internet()
    $IP = _GetIP()
    If $IP = -1 Then
        Logger("No Internet connection")
    Else
        Logger("IP address: " & $IP)
    EndIf
EndFunc

Func Parse()
    Run(@ComSpec & " /c " & 'findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >%userprofile%\Desktop\sfcdetails.txt')
    Logger("SFC log saved to desktop")
EndFunc

Func Search()
    Logger("Seaching for ...") ;DUMMY
EndFunc

Func Admin()
    If FileExists(@DesktopDir & "\Admin.bat") = 0 Then
        FileWrite(@DesktopDir & "\Admin.bat", $Admin_Text)
        Logger("Batch file to request admin rights is saved to desktop")
    Else
        Logger("File 'Admin.bat' already exists")
    EndIf
 EndFunc

Func Update()
    Local $Download = InetGet("https://raw.githubusercontent.com/qiiwexc/qiiwexc.github.io/master/dev/version", @TempDir & "\version", 1, 1)
    Do
        Sleep(250)
    Until InetGetInfo($Download, 2)
    $File = FileOpen(@TempDir & "\version")

    If $File = -1 Then
        If _GetIP() = -1 Then
            Logger("No Internet connection")
        Else
            Logger("An error occurred whilst checking for update")
        EndIf
    Else
        $New = FileReadLine($File)
        FileClose($File)
        FileDelete(@TempDir & "\version")
        If $VERSION = $New Then
            Logger("You have the latest version")
        Else
            $A_Version = StringSplit($VERSION, ".")
            $B_Version = StringSplit($New, ".")
            If $A_Version[1] < $B_Version[1] Then
                Logger("> Update is available: v" & $New & " <")
            Else
                If $A_Version[2] < $B_Version[2] Then
                    Logger("> Update is available: v" & $New & " <")
                Else
                    If $A_Version[3] < $B_Version[3] Then
                        Logger("> Update is available: v" & $New & " <")
                    Else
                        If $A_Version[4] < $B_Version[4] Then
                            Logger("> Update is available: v" & $New & " <")
                        Else
                            Logger("Something went wrong while checking for updates")
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf

EndFunc

Func Start()
    ;GUICtrlSendMsg($Progress, $PBM_SETMARQUEE, 1, 1)
    GUICtrlSetData($Progress, @SEC) ;DUMMY
    GUICtrlSetData($Start, "Pause")
    GUICtrlSetStyle($Stop, $WS_TABSTOP)
    Logger(@MSEC) ;DUMMY
    Title(@MSEC) ;DUMMY
EndFunc
