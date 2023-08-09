unit frLoading;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.TabControl, FMX.Layouts,
  FMX.ImgList, FMX.Edit, System.JSON, System.Threading, sgcWebSocket_Classes,
  sgcWebSocket_Classes_Indy, sgcWebSocket_Client, sgcWebSocket, sgcBase_Classes,
  sgcTCP_Classes, sgcWebSocket_Protocol_Base_Client,
  sgcWebSocket_Protocol_sgc_Client, sgcWebSocket_Protocols, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFLoading = class(TFrame)
    loMain: TLayout;
    background: TRectangle;
    tcMain: TTabControl;
    tiLoading: TTabItem;
    page1: TTabItem;
    logo: TImage;
    aniLoading: TAniIndicator;
    tiTransition: TTimer;
    tcWelcome: TTabControl;
    btnNext: TCornerButton;
    tiPage1: TTabItem;
    tiPage2: TTabItem;
    tiPage3: TTabItem;
    imgPage1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Label3: TLabel;
    Image2: TImage;
    btnBack: TCornerButton;
    QData: TFDMemTable;
    procedure Label1Click(Sender: TObject);
    procedure tiTransitionTimer(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    FShow : Boolean;
    procedure setFrame;
    procedure RPCResultLogin(Connection: TsgcWSConnection; Id, Result: string);
    procedure RPCResultError(Connection: TsgcWSConnection; Id: string; ErrorCode: Integer; ErrorMessage, ErrorData: string);
    procedure loginAccount(email, password : String);
  public
  published
    procedure FirstShow;  //ctrl + Shift + C
    procedure fnGoBack;
  end;

var
  FLoading : TFLoading;

implementation

{$R *.fmx}

uses BFA.Main, BFA.Env, frMain, BFA.Func, BFA.Websocket, BFA.Helper.MemTable,
  uDM;

{ TFTemp }

procedure TFLoading.btnBackClick(Sender: TObject);
begin
  tcWelcome.Previous;
end;

procedure TFLoading.btnNextClick(Sender: TObject);
begin
  if tcWelcome.TabIndex = tcWelcome.TabCount - 1 then begin
    SaveSettingString('config', 'onboarding', '1');
    fnGoFrame(goFrame, C_LOGIN);
  end else begin
    tcWelcome.Next;
  end;
end;

procedure TFLoading.FirstShow;
begin
  setFrame;
end;

procedure TFLoading.fnGoBack;
begin
  fnBack;
end;

procedure TFLoading.Label1Click(Sender: TObject);
begin
  fnGoFrame(goFrame, C_LOGIN);
end;

procedure TFLoading.loginAccount(email, password: String);
begin
  DM.wsProtocol.OnRPCResult := RPCResultLogin;
  DM.wsProtocol.OnRPCError := RPCResultError;

  fnLoading(True);
  try
    fnShowMessage('Logn Account!');
    var FResult : TJSONObject;
    var FJSON : String;

    FResult := TJSONObject.Create;
    try
      FResult.AddPair('email', email);
      FResult.AddPair('password', password);

      FJSON := '[' + FResult.ToJSON + ']';
    finally
      FResult.DisposeOf;
    end;

    if FJSON <> '' then
      DM.wsProtocol.RPC('', 'LoginMethod', FJSON);
  finally
    //fnLoading;
  end;
end;

procedure TFLoading.RPCResultError(Connection: TsgcWSConnection; Id: string;
  ErrorCode: Integer; ErrorMessage, ErrorData: string);
begin
  fnLoading(False);

  fnShowMessage(ErrorMessage, 1);
  fnGoFrame(C_LOADING, C_HOME);
end;

procedure TFLoading.RPCResultLogin(Connection: TsgcWSConnection; Id,
  Result: string);
begin
  fnLoading(False);

  if not QData.FillDataFromString(Result) then begin
    fnShowMessage(QData.FieldByName('messages').AsString);
    fnGoFrame(C_LOADING, C_LOGIN);
    Exit;
  end;

  if QData.FieldByName('status').AsInteger <> 200 then begin
    fnShowMessage(QData.FieldByName('messages').AsString);
    fnGoFrame(C_LOADING, C_LOGIN);
    Exit;
  end;

  fnShowMessage('Success Login!', 1);
  fnGoFrame(C_LOADING, C_HOME);
end;

procedure TFLoading.setFrame;
begin
  Self.Width := TControl(Self.Parent).Width;
  Self.Height := TControl(Self.Parent).Height;

  Self.Position.X := 0;
  Self.Position.Y := 0;
  tcMain.TabIndex := 0;

  Self.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];
  //Self.Align := TAlignLayout.Contents;

  TTask.Run(procedure begin
    Sleep(150);
    WebSocket.Connect(procedure begin
      TThread.Synchronize(nil, procedure begin
        tiTransition.Enabled := True;
      end);
    end);
  end).Start;


  if FShow then
    Exit;

  FShow := True;

end;

procedure TFLoading.tiTransitionTimer(Sender: TObject);
begin
  tiTransition.Enabled := False;
  aniLoading.Enabled := False;

  var FValue := LoadSettingString('config', 'onboarding', '');
  if FValue = '1' then begin
    var FEmail := LoadSettingString('config', 'email', '');
    var FPassword := LoadSettingString('config', 'password', '');

    DM.wsProtocol.Subscribe('transaction');

    TTask.Run(procedure begin
      loginAccount(FEmail, FPassword);
    end).Start;

    //fnGoFrame(C_LOADING, C_LOGIN);
  end else begin
    tcMain.Next;
    tcWelcome.TabIndex := 0;
  end;
end;

end.
