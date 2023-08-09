unit uDM;

interface

uses
  System.SysUtils, System.Classes, sgcWebSocket_Classes,
  sgcWebSocket_Classes_Indy, sgcWebSocket_Client, sgcWebSocket, sgcBase_Classes,
  sgcTCP_Classes, sgcWebSocket_Protocol_Base_Client,
  sgcWebSocket_Protocol_sgc_Client, sgcWebSocket_Protocols;

type
  TDM = class(TDataModule)
    wsProtocol: TsgcWSPClient_sgc;
    wsClient: TsgcWebSocketClient;
    procedure wsProtocolConnect(Connection: TsgcWSConnection);
    procedure wsProtocolDisconnect(Connection: TsgcWSConnection; Code: Integer);
    procedure wsProtocolEvent(Connection: TsgcWSConnection; const Channel,
      Text: string);
    procedure wsProtocolMessage(Connection: TsgcWSConnection;
      const Text: string);
    procedure wsProtocolRPCError(Connection: TsgcWSConnection; Id: string;
      ErrorCode: Integer; ErrorMessage, ErrorData: string);
    procedure wsProtocolRPCResult(Connection: TsgcWSConnection; Id,
      Result: string);
    procedure wsProtocolSubscription(Connection: TsgcWSConnection;
      const Subscription: string);
    procedure wsProtocolUnSubscription(Connection: TsgcWSConnection;
      const Subscription: string);
    procedure wsProtocolException(Connection: TsgcWSConnection; E: Exception);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses BFA.Func, frHome;

{$R *.dfm}

procedure TDM.wsProtocolConnect(Connection: TsgcWSConnection);
begin
  fnShowMessage('Connected to Server', 1);
end;

procedure TDM.wsProtocolDisconnect(Connection: TsgcWSConnection; Code: Integer);
begin
  fnShowMessage('Disconnected to Server');
end;

procedure TDM.wsProtocolEvent(Connection: TsgcWSConnection; const Channel,
  Text: string);
begin
  if Channel = 'transaction' then
    FHome.fnGetEvent(Text);
end;

procedure TDM.wsProtocolException(Connection: TsgcWSConnection; E: Exception);
begin
  fnShowMessage('Not Connect to Server!', 0);
end;

procedure TDM.wsProtocolMessage(Connection: TsgcWSConnection;
  const Text: string);
begin
//
end;

procedure TDM.wsProtocolRPCError(Connection: TsgcWSConnection; Id: string;
  ErrorCode: Integer; ErrorMessage, ErrorData: string);
begin
  fnLoading(False);
end;

procedure TDM.wsProtocolRPCResult(Connection: TsgcWSConnection; Id,
  Result: string);
begin
//
end;

procedure TDM.wsProtocolSubscription(Connection: TsgcWSConnection;
  const Subscription: string);
begin
//
end;

procedure TDM.wsProtocolUnSubscription(Connection: TsgcWSConnection;
  const Subscription: string);
begin
//
end;

end.
