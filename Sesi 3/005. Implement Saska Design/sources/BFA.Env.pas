unit BFA.Env;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  System.Generics.Collections, BFA.Websocket;

const
  C_LOADING       = 'LOADING';
  C_LOGIN         = 'LOGIN';
  C_HOME          = 'HOME';
  C_DETAIL        = 'DETAIL';
  C_PRODUCT       = 'PRODUCT';
  C_TRANSACTION   = 'TRANSACTION';

var
  goFrame, fromFrame : String;
  FListGo : TStringList;

  FTabCount : Integer;
  WebSocket : WSConnect;

implementation

end.
