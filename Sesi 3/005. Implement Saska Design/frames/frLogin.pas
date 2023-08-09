unit frLogin;

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
  TFLogin = class(TFrame)
    background: TRectangle;
    loMain: TLayout;
    tcMain: TTabControl;
    tiPage1: TTabItem;
    tiPage2: TTabItem;
    tiPage3: TTabItem;
    Image1: TImage;
    Label3: TLabel;
    btnFacebook: TCornerButton;
    glFacebook: TGlyph;
    CornerButton1: TCornerButton;
    Glyph1: TGlyph;
    CornerButton2: TCornerButton;
    Glyph2: TGlyph;
    Label1: TLabel;
    CornerButton3: TCornerButton;
    Label2: TLabel;
    btnBack: TCornerButton;
    Label4: TLabel;
    edEmailSignIn: TEdit;
    Glyph3: TGlyph;
    edPasswordSignIn: TEdit;
    Glyph4: TGlyph;
    CheckBox1: TCheckBox;
    btnProccessSignIn: TCornerButton;
    Label5: TLabel;
    Label6: TLabel;
    CornerButton5: TCornerButton;
    flLogin: TFlowLayout;
    CornerButton6: TCornerButton;
    CornerButton7: TCornerButton;
    Label7: TLabel;
    CornerButton4: TCornerButton;
    btnRegister: TCornerButton;
    CheckBox2: TCheckBox;
    edEmailSignUp: TEdit;
    Glyph5: TGlyph;
    edPasswordSignUp: TEdit;
    Glyph6: TGlyph;
    FlowLayout1: TFlowLayout;
    CornerButton9: TCornerButton;
    CornerButton10: TCornerButton;
    CornerButton11: TCornerButton;
    lblTitileSignUp: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Memo1: TMemo;
    QData: TFDMemTable;
    procedure Label1Click(Sender: TObject);
    procedure CornerButton3Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnProccessSignInClick(Sender: TObject);
  private
    FShow : Boolean;
    procedure setFrame;
    procedure createAccount(email, password : String);
    procedure loginAccount(email, password : String);

    procedure RPCResultRegister(Connection: TsgcWSConnection; Id, Result: string);
    procedure RPCResultLogin(Connection: TsgcWSConnection; Id, Result: string);
  public
  published
    procedure FirstShow;  //ctrl + Shift + C
    procedure fnGoBack;
  end;

var
  FLogin : TFLogin;

implementation

{$R *.fmx}

uses BFA.Main, BFA.Env, frMain, BFA.Func, uDM, BFA.Helper.MemTable;

{ TFTemp }

procedure TFLogin.btnBackClick(Sender: TObject);
begin
  tcMain.First;
end;

procedure TFLogin.btnProccessSignInClick(Sender: TObject);
begin
  TTask.Run(procedure begin
    loginAccount(edEmailSignIn.Text, edPasswordSignIn.Text);
  end).Start;
end;

procedure TFLogin.btnRegisterClick(Sender: TObject);
begin
  TTask.Run(procedure begin
    createAccount(edEmailSignUp.Text, edPasswordSignUp.Text);
  end).Start;
end;

procedure TFLogin.CornerButton3Click(Sender: TObject);
begin
  tcMain.Next;
end;

procedure TFLogin.createAccount(email, password: String);
begin
  DM.wsProtocol.OnRPCResult := RPCResultRegister;
  fnLoading(True);
  try
    fnShowMessage('Create Account!');
    var FResult : TJSONObject;
    var FJSON : String;

    FResult := TJSONObject.Create;
    try
      FResult.AddPair('email', email);
      FResult.AddPair('password', password);
      FResult.AddPair('username', '');
      FResult.AddPair('fullname', '');

      FJSON := '[' + FResult.ToJSON + ']';
    finally
      FResult.DisposeOf;
    end;

    if FJSON <> '' then
      DM.wsProtocol.RPC('', 'RegisterMethod', FJSON);
  finally
    //fnLoading;
  end;
end;

procedure TFLogin.FirstShow;
begin
  setFrame;
end;

procedure TFLogin.fnGoBack;
begin
  fnBack;
end;

procedure TFLogin.Label11Click(Sender: TObject);
begin
  tcMain.Previous;
end;

procedure TFLogin.Label1Click(Sender: TObject);
begin
  fnGoFrame(goFrame, C_HOME);
end;

procedure TFLogin.Label2Click(Sender: TObject);
begin
  tcMain.Last;
end;

procedure TFLogin.loginAccount(email, password: String);
begin
  DM.wsProtocol.OnRPCResult := RPCResultLogin;

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

    DM.wsProtocol.Subscribe('transaction');

    if FJSON <> '' then
      DM.wsProtocol.RPC('', 'LoginMethod', FJSON);
  finally
    //fnLoading;
  end;
end;

procedure TFLogin.setFrame;
begin
  Self.Width := TControl(Self.Parent).Width;
  Self.Height := TControl(Self.Parent).Height;

  Self.Position.X := 0;
  Self.Position.Y := 0;

  tcMain.TabIndex := 0;

  lblTitileSignUp.Text := 'Create your'#13 + 'Account';

  Self.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];

  if FShow then
    Exit;

  FShow := True;

end;

procedure TFLogin.RPCResultLogin(Connection: TsgcWSConnection; Id,
  Result: string);
begin
  fnLoading(False);

  if not QData.FillDataFromString(Result) then begin
    fnShowMessage(QData.FieldByName('messages').AsString);
    Exit;
  end;

  if QData.FieldByName('status').AsInteger <> 200 then begin
    fnShowMessage(QData.FieldByName('messages').AsString);
    Exit;
  end;

  SaveSettingString('config', 'email', edEmailSignIn.Text);
  SaveSettingString('config', 'password', edPasswordSignIn.Text);

  fnShowMessage('Success Login!', 1);
  fnGoFrame(C_LOGIN, C_HOME);
end;

procedure TFLogin.RPCResultRegister(Connection: TsgcWSConnection; Id,
  Result: string);
begin
  fnLoading(False);

  if not QData.FillDataFromString(Result) then begin
    fnShowMessage(QData.FieldByName('messages').AsString);
    Exit;
  end;

  if QData.FieldByName('status').AsInteger <> 200 then begin
    fnShowMessage(QData.FieldByName('messages').AsString);
    Exit;
  end;

  fnShowMessage('Success Register!', 1);
end;

end.
