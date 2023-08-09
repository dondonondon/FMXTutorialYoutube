unit frHome;

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
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.SearchBox, FMX.ListBox, FMX.Effects;

type
  TFHome = class(TFrame)
    btnProduct: TCornerButton;
    ciProfile: TCircle;
    lblWelcome: TLabel;
    lblEmail: TLabel;
    background: TRectangle;
    lbMain: TListBox;
    lbiMenu: TListBoxItem;
    lbiTitle: TListBoxItem;
    lbiHistory: TListBoxItem;
    edSearch: TEdit;
    lbMenu: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    btnTransaction: TCornerButton;
    Label1: TLabel;
    lblSeeAll: TLabel;
    lbHistory: TListBox;
    Glyph3: TGlyph;
    loTempTransaction: TLayout;
    glTempIcon: TGlyph;
    lblTempTransactionID: TLabel;
    lblTempValueTransaction: TLabel;
    reTempBackground: TRectangle;
    lblTempDate: TLabel;
    sbHistory: TSearchBox;
    QData: TFDMemTable;
    procedure Label1Click(Sender: TObject);
    procedure lblSeeAllClick(Sender: TObject);
    procedure edSearchTyping(Sender: TObject);
    procedure btnProductClick(Sender: TObject);
  private
    FShow : Boolean;
    procedure setFrame;
    procedure addTransactionItem(FValue : Single; FIDTransaction, FDate : String; isEvent : Boolean = False);

    procedure RPCResultLoadData(Connection: TsgcWSConnection; Id, Result: string);
    procedure fnLoadData;
  public
    procedure fnGetEvent(FJSON : String);
  published
    procedure FirstShow;  //ctrl + Shift + C
    procedure fnGoBack;
  end;

var
  FHome : TFHome;

implementation

{$R *.fmx}

uses BFA.Main, BFA.Env, uDM, frMain, BFA.Func, BFA.Helper.MemTable;

{ TFTemp }

procedure TFHome.addTransactionItem(FValue: Single; FIDTransaction, FDate: String; isEvent : Boolean);
begin
  var lb := TListBoxItem.Create(lbHistory);
  lb.Selectable := False;
  lb.Height := loTempTransaction.Height + 8;
  lb.Width := lbHistory.Width;
  lb.Text := FIDTransaction + ' ' + FDate;
  lb.FontColor := $00FFFFFF;
  lb.StyledSettings := [];

  var lo := TLayout(loTempTransaction.Clone(lb));
  lo.Width := lb.Width - 32;
  lo.Position.X := 16;
  lo.Position.Y := 0;

  lo.Visible := True;

  TLabel(lo.FindStyleResource(lblTempValueTransaction.StyleName)).Text :=
    Format('New transaction total value $%.2f', [FValue]);

  TLabel(lo.FindStyleResource(lblTempDate.StyleName)).Text := FDate;
  TLabel(lo.FindStyleResource(lblTempTransactionID.StyleName)).Text := FIDTransaction;

  lb.AddObject(lo);
  lbHistory.AddObject(lb);

  if isEvent then
    lb.Index := 0;
end;

procedure TFHome.btnProductClick(Sender: TObject);
begin
  fnGoFrame(C_HOME, TCornerButton(Sender).Hint);
end;

procedure TFHome.edSearchTyping(Sender: TObject);
begin
  sbHistory.Text := edSearch.Text;
end;

procedure TFHome.FirstShow;
begin
  setFrame;

  if lbHistory.Items.Count > 0 then
    Exit;

  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TFHome.fnGetEvent(FJSON: String);
begin
  var memData := TFDMemTable.Create(nil);
  try
    if not memData.FillDataFromString(FJSON) then begin
      fnShowMessage(memData.FieldByName('messages').AsString);
      Exit;
    end;

    try
      addTransactionItem(
        StrToFloatDef(memData.FieldByName('total_price').AsString, 0),
        memData.FieldByName('sub_id_transaction').AsString,
        memData.FieldByName('cdt').AsString,
        True
      );
    except

    end;
  finally
    memData.DisposeOf;
  end;
end;

procedure TFHome.fnGoBack;
begin
  fnBack;
end;

procedure TFHome.fnLoadData;
begin
  DM.wsProtocol.OnRPCResult := RPCResultLoadData;

  fnLoading(True);
  try
    fnShowMessage('Load Data');
    var SQLAdd :=
      'SELECT * FROM tbl_transaction ORDER BY cdt DESC';

    var FJSON :=
      '{'#13 +
      ' "query": "'+SQLAdd+'"'#13 +
      '}';

    DM.wsProtocol.RPC('', 'getTransaction', FJSON);
  finally
    //fnLoading;
  end;
end;

procedure TFHome.Label1Click(Sender: TObject);
begin
  fnGoFrame(C_HOME, C_DETAIL);
end;

procedure TFHome.lblSeeAllClick(Sender: TObject);
begin
  ShowMessage('');
end;

procedure TFHome.RPCResultLoadData(Connection: TsgcWSConnection; Id,
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

  if not QData.FillDataFromString(QData.FieldByName('data').AsString) then begin
    fnShowMessage(QData.FieldByName('messages').AsString);
    Exit;
  end;

  for var i := 0 to QData.RecordCount - 1 do begin
    addTransactionItem(
      StrToFloatDef(QData.FieldByName('total_price').AsString, 0),
      QData.FieldByName('sub_id_transaction').AsString,
      QData.FieldByName('cdt').AsString
    );

    QData.Next;
  end;
end;

procedure TFHome.setFrame;
begin
  lbiHistory.Height := lbMain.Height - (lbiMenu.Height + lbiTitle.Height);

  loTempTransaction.Visible := False;

  Self.Width := TControl(Self.Parent).Width;
  Self.Height := TControl(Self.Parent).Height;

  Self.Position.X := 0;
  Self.Position.Y := 0;

  Self.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];

  if FShow then
    Exit;

  FShow := True;

end;

end.
