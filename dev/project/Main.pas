unit Main;
{$mode delphi}{$H+}
interface
uses
  Classes, SysUtils, Forms, Windows, StdCtrls, LCLType, VersionTypes, VersionResource, shlobj;

type
  TMainForm = class(TForm)
    ButtonAdmin: TButton;
    ButtonUpdate: TButton;
    ButtonSMART : TButton;
    Log : TMemo;
    procedure ButtonAdminClick(Sender: TObject);
    procedure Logger(Text: string);
    procedure FormCreate(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    procedure ButtonSMARTClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation
{$R *.lfm}

  { Helper procedures and functions }

function AppVersion: string;
var
  Resource : TVersionResource;
  Info     : TVersionFixedInfo;
begin
  Resource := TVersionResource.Create;
  Resource.SetCustomRawDataStream(TResourceStream.CreateFromID(HINSTANCE, 1, PChar(RT_VERSION)));

  Info   := Resource.FixedInfo;
  Result := 'v' + IntToStr(Info.FileVersion[0]) +
            '.' + IntToStr(Info.FileVersion[1]) +
            '.' + IntToStr(Info.FileVersion[2]);
end;

function OSVersion: string;
begin
  Result := 'v' + IntToStr(Win32MajorVersion) + '.' + IntToStr(Win32MinorVersion);
  case Win32MajorVersion of
    4:
      case Win32MinorVersion of
        0:  Result := '95';
        10: Result := '98';
        90: Result := 'ME';
      end;
    5:
      case Win32MinorVersion of
        0: Result := '2000';
        1: Result := 'XP';
      end;
    6:
      case Win32MinorVersion of
        0: Result := 'Vista';
        1: Result := '7';
        2: Result := '8';
        3: Result := '8.1';
      end;
    10:
      case Win32MinorVersion of
        0: Result := '10';
      end;
  end;
  Result := 'Windows ' + Result;
end;

function OSArchitecture: string;
var
  IsWow64Process : function(hProcess : THandle; var Wow64Process : BOOL): BOOL; stdcall;
  Wow64Process   : BOOL;
begin
  Wow64Process   := false;
  IsWow64Process := GetProcAddress(GetModuleHandle(Kernel32), 'IsWow64Process');
  if Assigned(IsWow64Process) then
    if IsWow64Process(GetCurrentProcess, Wow64Process) then
      Result := '64'
    else
      Result := '86';
end;

function OSLanguage: string;
var
  Buffer : PChar;
  Size   : integer;
begin
  Size := GetLocaleInfo (LOCALE_USER_DEFAULT, LOCALE_SENGLANGUAGE, nil, 0);
  GetMem(Buffer, Size);
  GetLocaleInfo (LOCALE_USER_DEFAULT, LOCALE_SENGLANGUAGE, Buffer, Size);
  Result := Buffer;
end;

procedure TMainForm.Logger(Text: string);
begin
  Log.Append(FormatDateTime('DD.MM.YYYY hh:mm:ss.zzz', Now) + ' - ' + Text);
end;

procedure CheckForUpdates;
begin
  MainForm.Logger('aaa');
end;

  { Event handlers }

procedure TMainForm.ButtonUpdateClick(Sender: TObject);
begin
  CheckForUpdates();
end;

procedure TMainForm.ButtonAdminClick(Sender: TObject);
var
  Path   : PChar;
  //Path : string;
  AdminFile : TextFile;
  //Lines     : array [1..17] of string;
begin
  AssignFile(AdminFile, 'Admin.bat');
  Path := '';
  SHGetSpecialFolderPath(0, Path, CSIDL_DESKTOPDIRECTORY, false);
  //Path := Desktop;
  Logger(Path + 'Admin.bat');

  //{$I+}
  try
    rewrite(AdminFile);
    writeln(AdminFile, 'Hello textfile!');
    CloseFile(AdminFile);
  except
    on E: EInOutError do
      Logger('File handling error occurred. Details: ' + E.ClassName + '/' + E.Message);
  end;
  Logger('File Admin.bat created if all went ok. Press Enter to stop.');

  //Lines[1]  := '@echo off';
  //Lines[2]  := '>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"';
  //Lines[3]  := 'if "%errorlevel%" NEQ "0" (';
  //Lines[4]  := 'echo Requesting administrative privileges...';
  //Lines[5]  := 'goto UACPrompt';
  //Lines[6]  := ') else ( goto gotAdmin )';
  //Lines[7]  := ':UACPrompt';
  //Lines[8]  := 'echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"';
  //Lines[9]  := 'set params = %*:"=""';
  //Lines[10] := 'echo UAC.ShellExecute "%~s0", "%params%", "", "runas", 1 >> "%temp%\getadmin.vbs"';
  //Lines[11] := '"%temp%\getadmin.vbs"';
  //Lines[12] := 'exit /B';
  //Lines[13] := ':gotAdmin';
  //Lines[14] := 'if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )';
  //Lines[15] := 'pushd "%CD%"';
  //Lines[16] := 'CD /D "%~dp0"';
  //Lines[17] := '::----PLACE----YOUR----CODE----BELOW----';
  //
  //try
  //  AdminFile := TFileStream.Create(Desktop + '\Admin.bat', fmCreate);
  //  //AdminFile.write(Lines[1], length(Lines[1]));
  //  //AdminFile.write(Lines[2], length(Lines[2]));
  //  AdminFile.write(Lines[3], length(Lines[3]));
  //  AdminFile.Free;
  //  Logger('File Admin.bat was successfully saved to desktop.');
  //except
  //  on E: EInOutError do
  //    Logger('File handling error occurred. Details: ' + E.ClassName + '/' + E.Message);
  //end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Application.Title := Application.Title + ' ' + AppVersion();
  MainForm.Caption  := Application.Title;
  Logger(Application.Title + ' started');
  Logger('Running on ' + OSVersion() + ' (x' + OSArchitecture() + ') ' + OSLanguage());
  CheckForUpdates();
end;

procedure TMainForm.ButtonSMARTClick(Sender: TObject);
begin
  Application.MessageBox(
    'Value: higher is better' + sLineBreak +
    'Threshold: must be higher than Value' + sLineBreak +
    'Worst: the lowest value ever registered' + sLineBreak +
    'Raw: current value in hex' + sLineBreak +
    'Type: attribute type:' + sLineBreak +
    '  - PR: Performance-related' + sLineBreak +
    '  - ER: Error rate' + sLineBreak +
    '  - EC: Events count' + sLineBreak +
    '  - SP: Self-preserve'
    , 'HDD S.M.A.R.T. Info', MB_ICONINFORMATION);
end;

end.
