unit BFA.Env;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  System.Rtti, System.Threading, Generics.Collections;

type
  Helper = class
  public
    class function getFontSize : Single;
    class function getIdle : Integer;
  end;

const
  //FRAME IDENTIFY
  C_TEMP = 'TEMP';
  C_LOADING = 'LOADING';
  C_HOME = 'HOME';
  C_LOGIN = 'LOGIN';
  C_DETAIL = 'DETAIL';
  C_ACCOUNT = 'ACCOUNT';

var
  FListGo : TStringList;
  goFrame, fromFrame, FToken : String;
  FTabCount : Integer;
  FPopUp : Boolean;
  ListMenu : TList<TCornerButton>;

implementation

{ Helper }

class function Helper.getFontSize: Single;
begin
  Result := 12.5;
end;

class function Helper.getIdle: Integer;
begin
  Result := 400;
end;

end.
