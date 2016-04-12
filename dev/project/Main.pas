unit Main;
{$mode delphi}{$H+}
interface

uses
  Classes, SysUtils, Forms, Process, Windows, StdCtrls, VersionTypes, VersionResource, HTTPSend;

type

  { TMainForm }

  TMainForm = class(TForm)
    ButtonAdmin    : TButton;
    ButtonParseSFC : TButton;
    ButtonSMART    : TButton;
    ButtonUpdate   : TButton;
    Log            : TMemo;
    procedure ButtonParseSFCClick(Sender: TObject);
    procedure FormCreate        (Sender: TObject);
    procedure ButtonAdminClick  (Sender: TObject);
    procedure ButtonSMARTClick  (Sender: TObject);
    procedure ButtonUpdateClick (Sender: TObject);
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

procedure Logger(Text: string);
begin
  MainForm.Log.Append(FormatDateTime('DD.MM.YYYY hh:mm:ss.zzz', Now) + ' - ' + Text);
end;

function Download(URL: string; SavePath: string = ''; SaveName: string = ''; Save: bool = true): string;
var
  httpClient : THTTPSend;
  Name       : TStringList;
  Success    : bool;
  Code       : integer;
begin
  if SavePath <> '' then SavePath := SavePath + '\';

  if SaveName = '' then
  begin
    Name               := TStringList.Create;
    Name.Delimiter     := '/';
    Name.DelimitedText := URL;
    SaveName           := Name[Name.Count - 1];
    Name.Free;
  end;

  httpClient := THTTPSend.Create;
  Success    := httpClient.HTTPMethod('GET', URL);
  Code       := httpClient.ResultCode;

  if Success and (Code >= 100) and (Code <= 299) then
  begin
    if Save then httpClient.Document.SaveToFile(SavePath + SaveName)
    else
    begin
      SetString(Result, PAnsiChar(httpClient.Document.Memory), httpClient.Document.Size);
    end;
  end
  else Result := '-1';

  httpClient.Free;
end;

function AppVersion: string;
var
  Resource : TVersionResource;
  Info     : TVersionFixedInfo;
begin
  Resource := TVersionResource.Create;
  Resource.SetCustomRawDataStream(TResourceStream.CreateFromID(HINSTANCE, 1, PChar(RT_VERSION)));

  Info   := Resource.FixedInfo;
  Result := IntToStr(Info.FileVersion[0]) +
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
  IsWow64Process : function(hProcess: THandle; var Wow64Process: bool): bool; stdcall;
  Wow64Process   : bool;
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

function CheckForUpdates: string;
var
  CurrentVersion : TStringList;
  NewVersion     : TStringList;
  Release        : string;
begin
  Release := Download('http://qiiwexc.github.io/dev/version', '', '', false);

  if Release <> '-1' then
  begin
    Release := Copy(Release, 0, length(Release) - 1);

    CurrentVersion               := TStringList.Create;
    CurrentVersion.Delimiter     := '.';
    CurrentVersion.DelimitedText := AppVersion();

    NewVersion                   := TStringList.Create;
    NewVersion.Delimiter         := '.';
    NewVersion.DelimitedText     := Release;

    if StrToInt(NewVersion[0]) > StrToInt(CurrentVersion[0]) then Result := Release
    else
    begin
      if StrToInt(NewVersion[1]) > StrToInt(CurrentVersion[1]) then Result := Release
      else
      begin
        if StrToInt(NewVersion[2]) > StrToInt(CurrentVersion[2]) then Result := Release
        else Result := '0'
      end;
    end;

    CurrentVersion.Free;
    NewVersion.Free;
  end
  else Result := Release;

end;

  { Event handlers }

procedure TMainForm.ButtonAdminClick(Sender: TObject);
begin
  Logger(Download('http://qiiwexc.github.io/downloads/Admin.bat'));
end;

procedure TMainForm.ButtonParseSFCClick(Sender: TObject);
var
  s: string;
begin
  //RunCommand('c:\windows\system32\cmd.exe', ['/c', '%windir%\Logs\CBS\CBS.log>%userprofile%\Desktop\sfcdetails.txt'], s);
  //RunCommand('c:\windows\system32\cmd.exe', ['/c', 'echo a>%userprofile%\Desktop\sfcdetails.txt'], s);
  ExecuteProcess('cmd', '/c %windir%\Logs\CBS\CBS.log>%userprofile%\Desktop\sfcdetails.txt');
  Logger('SFC log parsed and saved as "sfcdetails.txt"');
  Logger(s);
end;

procedure TMainForm.ButtonSMARTClick(Sender: TObject);
begin
  Application.MessageBox(
    'Value: higher is better'                 + sLineBreak +
    'Threshold: must be higher than Value'    + sLineBreak +
    'Worst: the lowest value ever registered' + sLineBreak +
    'Raw: current value in hex'               + sLineBreak +
    'Type: attribute type:'                   + sLineBreak +
    '  - PR: Performance-related'             + sLineBreak +
    '  - ER: Error rate'                      + sLineBreak +
    '  - EC: Events count'                    + sLineBreak +
    '  - SP: Self-preserve'
    , 'HDD S.M.A.R.T. Info', MB_ICONINFORMATION);
end;

procedure TMainForm.ButtonUpdateClick(Sender: TObject);
var
  CheckResult: string;
begin
  CheckResult := CheckForUpdates();

  if ButtonUpdate.Caption = 'Check For Updates' then
  begin
    if      CheckResult =  '0' then Logger('You are using the latest version!')
    else if CheckResult = '-1' then Logger('Something went wrong while checking for updates.')
    else
    begin
      Logger('New version is available: v' + CheckResult);
      ButtonUpdate.Caption := 'Update to v' + CheckResult;
    end;
  end
  else
  begin
    Logger('Updating!');
    //Download('http://qiiwexc.github.io/dev/project/qiiwexc.exe');
  end;

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Application.Title := Application.Title + ' v' + AppVersion();
  MainForm.Caption  := Application.Title;

  Logger(Application.Title + ' started');
  Logger('Running on ' + OSVersion() + ' (x' + OSArchitecture() + ') ' + OSLanguage());

  ButtonUpdate.Click;
end;

end.
