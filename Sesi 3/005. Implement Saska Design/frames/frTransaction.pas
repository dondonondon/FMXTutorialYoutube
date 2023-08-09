unit frTransaction;

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
  TFTransaction = class(TFrame)
    background: TRectangle;
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    loMain: TLayout;
    btnBack: TCornerButton;
    lblTitle: TLabel;
    tcMain: TTabControl;
    tiData: TTabItem;
    lbProduct: TListBox;
    sbSearch: TSearchBox;
    Glyph3: TGlyph;
    btnCart: TCornerButton;
    tiProcces: TTabItem;
    loTempViewData: TLayout;
    reTempBackground: TRectangle;
    lblTempProductName: TLabel;
    lblTempPrice: TLabel;
    QData: TFDMemTable;
    btnAdd: TCornerButton;
    lblTotalCart: TLabel;
    lbCart: TListBox;
    btnProccess: TCornerButton;
    Memo1: TMemo;
    procedure btnBackClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender : TObject);
    procedure btnCartClick(Sender: TObject);
    procedure btnProccessClick(Sender: TObject);
  private
    FShow : Boolean;
    procedure setFrame;
    procedure addItemProduct(FIndex : Integer; FProductName : String; FPrice : Single);
    procedure addItemCart(FIndex : Integer; FProductName : String; FPrice : Single);
    procedure RPCResultLoadData(Connection: TsgcWSConnection; Id, Result: string);
    procedure RPCResultTransaction(Connection: TsgcWSConnection; Id, Result: string);
    procedure fnLoadData;

    function addJSON(FType, FQuery : String) : String;
    function createTransaction : String;

    procedure procesItem;
  public
  published
    procedure FirstShow;  //ctrl + Shift + C
    procedure fnGoBack;
  end;

var
  FTransaction : TFTransaction;

implementation

{$R *.fmx}

uses BFA.Main, BFA.Env, BFA.Func, frMain, uDM, BFA.Helper.MemTable;

{ TFTemp }

procedure TFTransaction.addItemCart(FIndex: Integer; FProductName: String;
  FPrice: Single);
begin
  var lb := TListBoxItem.Create(lbCart);
  lb.Selectable := False;
  lb.Height := loTempViewData.Height + 8;
  lb.Width := lbCart.Width;
  lb.Text := FProductName;
  lb.FontColor := $00FFFFFF;
  lb.StyledSettings := [];

  lb.Tag := FIndex;

  var lo := TLayout(loTempViewData.Clone(lb));
  lo.Width := lb.Width - 32;
  lo.Position.X := 16;
  lo.Position.Y := 4;

  lo.Visible := True;

  TLabel(lo.FindStyleResource(lblTempProductName.StyleName)).Text := FProductName;
  TLabel(lo.FindStyleResource(lblTempPrice.StyleName)).Text := Format('%.2f', [FPrice]);

  TCornerButton(lo.FindStyleResource(btnAdd.StyleName)).ImageIndex := 12;
  TCornerButton(lo.FindStyleResource(btnAdd.StyleName)).OnClick := btnDelClick;
  TCornerButton(lo.FindStyleResource(btnAdd.StyleName)).Tag := FIndex;

  lb.AddObject(lo);
  lbCart.AddObject(lb);
end;

procedure TFTransaction.addItemProduct(FIndex: Integer; FProductName: String;
  FPrice: Single);
begin
  var lb := TListBoxItem.Create(lbProduct);
  lb.Selectable := False;
  lb.Height := loTempViewData.Height + 8;
  lb.Width := lbProduct.Width;
  lb.Text := FProductName;
  lb.FontColor := $00FFFFFF;
  lb.StyledSettings := [];

  lb.Tag := FIndex;

  var lo := TLayout(loTempViewData.Clone(lb));
  lo.Width := lb.Width - 32;
  lo.Position.X := 16;
  lo.Position.Y := 4;

  lo.Visible := True;

  lo.StyleName := 'loTemp';

  TLabel(lo.FindStyleResource(lblTempProductName.StyleName)).Text := FProductName;
  TLabel(lo.FindStyleResource(lblTempPrice.StyleName)).Text := Format('%.2f', [FPrice]);

  TCornerButton(lo.FindStyleResource(btnAdd.StyleName)).OnClick := btnAddClick;
  TCornerButton(lo.FindStyleResource(btnAdd.StyleName)).Tag := FIndex;

  lb.AddObject(lo);
  lbProduct.AddObject(lb);
end;

function TFTransaction.addJSON(FType, FQuery: String): String;
begin
  Result :=
    '{'#13 +
    ' "type": "'+FType+'",'#13 +
    ' "data": ['#13 +
    '   {'#13 +
    '   "query": "'+FQuery+'"'#13 +
    '   }'#13 +
    ' ]'#13 +
    '}';
end;

procedure TFTransaction.btnAddClick(Sender: TObject);
begin
  QData.RecNo := TCornerButton(Sender).Tag;

  if TCornerButton(Sender).ImageIndex = 10 then begin
    TCornerButton(Sender).ImageIndex := 12;

    addItemCart(QData.RecNo,
      QData.FieldByName('product_name').AsString,
      StrToFloatDef(QData.FieldByName('price').AsString, 0)
    );
  end else begin
    TCornerButton(Sender).ImageIndex := 10;

    for var i := 0 to lbCart.Items.Count - 1 do begin
      if lbCart.ItemByIndex(i).Tag = QData.RecNo then begin
        lbCart.Items.Delete(i);
        Break;
      end;
    end;
  end;

  lblTotalCart.Text := lbCart.Items.Count.ToString;

end;

procedure TFTransaction.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFTransaction.btnCartClick(Sender: TObject);
begin
  tcMain.Next;
end;

procedure TFTransaction.btnDelClick(Sender: TObject);
begin
  var B := TCornerButton(Sender);
  var lo := TLayout(B.Parent);
  var lb := TListBoxItem(lo.Parent);

  var lbp : TListBoxItem;
  var lop : TLayout;

  for var i := 0 to lbProduct.Items.Count - 1 do begin
    if lbProduct.ItemByIndex(i).Tag = B.Tag then begin
      lbp := lbProduct.ItemByIndex(i);
      Break;
    end;
  end;

  if Assigned(lbp) then begin
    for var i := 0 to lbp.ControlsCount - 1 do begin
      if lbp.Controls[i] is TLayout then begin
        if TLayout(lbp.Controls[i]).StyleName = 'loTemp' then begin
          lop := TLayout(lbp.Controls[i]);
          Break;
        end;
      end;
    end;
  end;

  if Assigned(lop) then begin
    TCornerButton(lop.FindStyleResource(btnAdd.StyleName)).ImageIndex := 10;
  end;

  lbCart.Items.Delete(lb.Index);
  lblTotalCart.Text := lbCart.Items.Count.ToString;
end;

procedure TFTransaction.btnProccessClick(Sender: TObject);
begin
  //Memo1.Lines.Clear;
  //Memo1.Lines.Add(createTransaction);
  if lbCart.Items.Count = 0 then begin
    fnShowMessage('No item on cart!', 2);
    Exit;
  end;

  TTask.Run(procedure begin
    procesItem;
  end).Start;
end;

function TFTransaction.createTransaction: String;
begin
  var FResult, FData : TJSONObject;
  var FTemp : TJsonArray;
  var FJSON : String;
  var FSubPrice : Single;

  FSubPrice := 0;
  for var i := 0 to lbCart.Items.Count - 1 do begin
    QData.RecNo := lbCart.ItemByIndex(i).Tag;
    FSubPrice := FSubPrice + StrToFloatDef(QData.FieldByName('price').AsString, 0);
  end;

  FResult := TJSONObject.Create;
  try
    FResult.AddPair('sub_id_transaction', 'TR.' + FormatDateTime('yyyymmddhhnnssz', Now) + '.' + Random(100).ToString);
    FResult.AddPair('cdt', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
    FResult.AddPair('sub_price', FSubPrice.ToString);
    FResult.AddPair('discount', '10');
    FResult.AddPair('total_price', (FSubPrice - (FSubPrice * (10 / 100))).toString);

    FTemp := TJSONArray.Create;
    for var i := 0 to lbCart.Items.Count - 1 do begin
      QData.RecNo := lbCart.ItemByIndex(i).Tag;

      FData := TJSONObject.Create;

      FData.AddPair('id_product', QData.FieldByName('id_product').AsString);
      FData.AddPair('price', QData.FieldByName('price').AsString);

      FTemp.AddElement(FData);
    end;

    FResult.AddPair('data', FTemp);

    Result := (FResult.ToJSON);

  finally
    FResult.DisposeOf;
  end;
end;

procedure TFTransaction.FirstShow;
begin
  setFrame;

  lbProduct.Items.Clear;
  lbCart.Items.Clear;
  lblTotalCart.Text := '0';

  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TFTransaction.fnGoBack;
begin
  if tcMain.TabIndex = 1 then begin
    tcMain.Previous;
  end else begin
    fnBack;
  end;
end;

procedure TFTransaction.fnLoadData;
begin
  DM.wsProtocol.OnRPCResult := RPCResultLoadData;

  fnLoading(True);
  try
    fnShowMessage('Load Data');
    var SQLAdd :=
      'SELECT * FROM tbl_product WHERE status = 1';
    DM.wsProtocol.RPC('', 'CRUDProduct', addJSON('GETDATA', SQLAdd));
  finally
    //fnLoading;
  end;
end;

procedure TFTransaction.procesItem;
begin
  DM.wsProtocol.OnRPCResult := RPCResultTransaction;

  fnLoading(True);
  try
    fnShowMessage('Proces Transaction');
    DM.wsProtocol.RPC('', 'TransactionProduct', createTransaction);
  finally
    //fnLoading;
  end;
end;

procedure TFTransaction.RPCResultLoadData(Connection: TsgcWSConnection; Id,
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
    addItemProduct(
      QData.RecNo,
      QData.FieldByName('product_name').AsString,
      StrToFloatDef(QData.FieldByName('price').AsString, 0)
    );

    QData.Next;
  end;
end;

procedure TFTransaction.RPCResultTransaction(Connection: TsgcWSConnection; Id,
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

  lbProduct.Items.Clear;
  lbCart.Items.Clear;
  lblTotalCart.Text := '0';

  tcMain.Previous;

  fnShowMessage('Transaction Success!');

  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TFTransaction.setFrame;
begin
  Self.Width := TControl(Self.Parent).Width;
  Self.Height := TControl(Self.Parent).Height;

  loTempViewData.Visible := False;
  tcMain.TabIndex := 0;

  Self.Position.X := 0;
  Self.Position.Y := 0;

  Self.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];

  if FShow then
    Exit;

  FShow := True;

end;

end.
