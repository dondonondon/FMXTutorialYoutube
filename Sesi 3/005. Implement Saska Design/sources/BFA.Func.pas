unit BFA.Func;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, System.ImageList, FMX.ImgList,
  FMX.TabControl, FMX.Edit, System.IniFiles, System.IOUtils;

function getAppsLocation : String;
procedure fnLog(FMessages : String);
procedure fnShowMessage(FMessages : String; FType : Integer = 2);
procedure fnLoading(FState : Boolean = False);
procedure SaveSettingString(Section, Name, Value: string);
function LoadSettingString(Section, Name, Value: string): string;

implementation

uses BFA.Helper.Main;

function getAppsLocation : String;
begin
  {$IF DEFINED (MSWINDOWS)}
    Result := ExpandFileName(GetCurrentDir) + PathDelim;
  {$ELSE}
    Result := TPath.GetDocumentsPath + PathDelim;
  {$ENDIF}
end;

procedure fnLog(FMessages : String);
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(getAppsLocation + 'log.ini');
  try
    ini.WriteString('log', FormatDateTime('yyyy-mm-dd hh:nn:ss:zz', Now), FMessages);
  finally
    ini.DisposeOf;
  end;
end;

procedure fnShowMessage(FMessages : String; FType : Integer);
begin
  TThread.Synchronize(nil, procedure begin
    if Assigned(TForm(Screen.ActiveForm)) then
      TForm(Screen.ActiveForm).ShowToastMessage(FMessages, FType);
  end);
end;

function LoadSettingString(Section, Name, Value: string): string;
var
  ini: TIniFile;
begin
  {$IF DEFINED (ANDROID)}
  ini := TIniFile.Create(TPath.GetDocumentsPath + PathDelim + 'config.ini');
  {$ELSEIF DEFINED (MSWINDOWS)}
  if not DirectoryExists(TPath.GetPublicPath + PathDelim + 'BFA') then
    CreateDir(TPath.GetPublicPath + PathDelim + 'BFA');
  ini := TIniFile.Create(TPath.GetPublicPath + PathDelim + 'BFA' + PathDelim + 'config.ini');
  {$ENDIF}
  try
    Result := ini.ReadString(Section, Name, Value);
  finally
    ini.DisposeOf;
  end;
end;

procedure SaveSettingString(Section, Name, Value: string);
var
  ini: TIniFile;
begin
  {$IF DEFINED (ANDROID)}
  ini := TIniFile.Create(TPath.GetDocumentsPath + PathDelim + 'config.ini');
  {$ELSEIF DEFINED (MSWINDOWS)}
  if not DirectoryExists(TPath.GetPublicPath + PathDelim + 'BFA') then
    CreateDir(TPath.GetPublicPath + PathDelim + 'BFA');

  ini := TIniFile.Create(TPath.GetPublicPath + PathDelim + 'BFA' + PathDelim + 'config.ini');
  {$ENDIF}
  try
    ini.WriteString(Section, Name, Value);
  finally
    ini.DisposeOf;
  end;
end;

procedure fnLoading(FState : Boolean = False);
begin
  TThread.Synchronize(nil, procedure begin
    if Assigned(TForm(Screen.ActiveForm)) then begin
      TForm(Screen.ActiveForm).heLoading(FState);
    end;
  end);
end;

end.
