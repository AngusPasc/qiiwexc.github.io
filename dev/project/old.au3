TODO: updates, zip, search, control panel buttons and common actions, utilities, preferences, statistics, configuration file, registry, icon

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
    GUICtrlSetData($Progress, @SEC) ;DUMMY
    GUICtrlSetData($Start, "Pause")
    GUICtrlSetStyle($Stop, $WS_TABSTOP)
    Logger(@MSEC) ;DUMMY
    Title(@MSEC) ;DUMMY
EndFunc
