unit BFA.Websocket;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, sgcWebSocket_Classes,
  sgcWebSocket_Protocol_Base_Client, sgcWebSocket_Protocol_sgc_Client,
  sgcWebSocket_Protocols, sgcBase_Classes, sgcTCP_Classes,
  sgcWebSocket_Classes_Indy, sgcWebSocket_Client, sgcWebSocket, sgcJSON;

type
  WSConnect = class
  private
    FProtocol: TsgcWSPClient_sgc;
    FClient: TsgcWebSocketClient;
    procedure setProtocol(const Value: TsgcWSPClient_sgc);
    procedure setClient(const Value: TsgcWebSocketClient);
  public
    property Protocol : TsgcWSPClient_sgc read FProtocol write setProtocol;
    property Client : TsgcWebSocketClient read FClient write setClient;

    procedure Connect(FProc : TProc = nil);

    constructor Create;
    destructor Destroy;
  end;

const
  C_PORT = 5414;
  C_HOST = '127.0.0.1';

implementation

{ WSConnect }

uses BFA.Func;

procedure WSConnect.Connect(FProc: TProc);
begin
  if not Assigned(FProtocol) then begin
    fnShowMessage('Protocol not define!', 0);
    Exit;
  end;

  if not Assigned(FClient) then begin
    fnShowMessage('Client not define!', 0);
    Exit;
  end;

  sgcJSON.SetJSONClass(TsgcJSON);
  FClient.Port := C_PORT;
  FClient.Host := C_HOST;

  FClient.Active := True;
  if FClient.Active then begin
    if Assigned(FProc) then
      FProc;
  end;
end;

constructor WSConnect.Create;
begin

end;

destructor WSConnect.Destroy;
begin

end;

procedure WSConnect.setClient(const Value: TsgcWebSocketClient);
begin
  FClient := Value;
end;

procedure WSConnect.setProtocol(const Value: TsgcWSPClient_sgc);
begin
  FProtocol := Value;
end;

end.
