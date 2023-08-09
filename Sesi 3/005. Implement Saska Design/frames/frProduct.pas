unit frProduct;

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
  TFProduct = class(TFrame)
    background: TRectangle;
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    loMain: TLayout;
    btnBack: TCornerButton;
    lblTitle: TLabel;
    tcMain: TTabControl;
    tiData: TTabItem;
    tiProcces: TTabItem;
    loTempViewData: TLayout;
    lblTempProductName: TLabel;
    lblTempQty: TLabel;
    lblTempPrice: TLabel;
    lbProduct: TListBox;
    sbSearch: TSearchBox;
    Glyph3: TGlyph;
    QData: TFDMemTable;
    reTempBackground: TRectangle;
    edProductName: TEdit;
    Label1: TLabel;
    edQuantity: TEdit;
    Label2: TLabel;
    edPrice: TEdit;
    Label3: TLabel;
    btnProccess: TCornerButton;
    btnRed: TCornerButton;
    btnAddProduct: TCornerButton;
    procedure btnBackClick(Sender: TObject);
    procedure lbProductItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnAddProductClick(Sender: TObject);
    procedure btnProccessClick(Sender: TObject);
    procedure btnRedClick(Sender: TObject);
  private
    FShow : Boolean;
    FTypeProccess : String;
    procedure setFrame;
    procedure addItemProduct(FIndex : Integer; FProductName : String; FQTY : Integer; FPrice : Single);

    procedure RPCResultLoadData(Connection: TsgcWSConnection; Id, Result: string);
    procedure RPCResultProccess(Connection: TsgcWSConnection; Id, Result: string);

    function addJSON(FType, FQuery : String) : String;
    procedure fnLoadData;
    procedure fnClear;

    procedure fnProccess(FType : String);
  public
  published
    procedure FirstShow;  //ctrl + Shift + C
    procedure fnGoBack;
  end;

var
  FProduct : TFProduct;

const
  C_INSERT = 'INSERT';
  C_DELETE = 'DELETE';
  C_UPDATE = 'UPDATE';

implementation

{$R *.fmx}

uses BFA.Main, BFA.Env, BFA.Func, frMain, uDM, BFA.Helper.MemTable;

{ TFTemp }

procedure TFProduct.addItemProduct(FIndex : Integer; FProductName: String; FQTY: Integer;
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

  TLabel(lo.FindStyleResource(lblTempProductName.StyleName)).Text := FProductName;
  TLabel(lo.FindStyleResource(lblTempQty.StyleName)).Text := FQTY.ToString;
  TLabel(lo.FindStyleResource(lblTempPrice.StyleName)).Text := Format('%.2f', [FPrice]);

  lb.AddObject(lo);
  lbProduct.AddObject(lb);
end;

function TFProduct.addJSON(FType, FQuery: String): String;
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

procedure TFProduct.btnAddProductClick(Sender: TObject);
begin
  fnClear;

  FTypeProccess := C_INSERT;
  tcMain.Next;
end;

procedure TFProduct.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFProduct.btnProccessClick(Sender: TObject);
begin
  TTask.Run(procedure begin
    fnProccess(FTypeProccess);
  end).Start;
end;

procedure TFProduct.btnRedClick(Sender: TObject);
begin
  TTask.Run(procedure begin
    fnProccess(C_DELETE);
  end).Start;
end;

procedure TFProduct.FirstShow;
begin
  setFrame;

  lbProduct.Items.Clear;
  TTask.Run(procedure begin
    fnLoadData;
  end).Start;

end;

procedure TFProduct.fnClear;
begin
  FTypeProccess := C_INSERT;
  edProductName.Text := '';
  edQuantity.Text := '';
  edPrice.Text := '';
end;

procedure TFProduct.fnGoBack;
begin
  if tcMain.TabIndex = 1 then begin
    tcMain.Previous;
    fnClear;
  end else begin
    fnBack;
  end;
end;

procedure TFProduct.fnLoadData;
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

procedure TFProduct.fnProccess(FType: String);
var
  SQLAdd : String;
begin
  if FType = C_INSERT then begin
    SQLAdd := Format(
      'INSERT INTO tbl_product (cdt, product_name, qty, price, status) VALUES(''%s'', ''%s'', ''%s'', ''%s'', ''%s'')',
      [
        FormatDateTime('yyyy-mm-dd hh:nn:ss', Now),
        edProductName.Text,
        edQuantity.Text,
        edPrice.Text,
        '1'
      ]
    );
  end else if FType = C_UPDATE then begin
    SQLAdd := Format(
      'UPDATE tbl_product SET product_name = ''%s'', qty = ''%s'', price = ''%s'' WHERE id_product = ''%s''',
      [
        edProductName.Text,
        edQuantity.Text,
        edPrice.Text,
        QData.FieldByName('id_product').AsString
      ]
    );
  end else if FType = C_DELETE then begin
    SQLAdd := Format(
      'UPDATE tbl_product SET status = ''%s'' WHERE id_product = ''%s''',
      [
        '0',
        QData.FieldByName('id_product').AsString
      ]
    );
  end;

  DM.wsProtocol.OnRPCResult := RPCResultProccess;

  if SQLAdd <> '' then
    DM.wsProtocol.RPC('', 'CRUDProduct', addJSON(FType, SQLAdd));
end;

procedure TFProduct.lbProductItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  QData.RecNo := Item.Tag;

  FTypeProccess := C_UPDATE;

  edProductName.Text := QData.FieldByName('product_name').AsString;
  edQuantity.Text := QData.FieldByName('qty').AsString;
  edPrice.Text := QData.FieldByName('price').AsString;

  tcMain.Next;
end;

procedure TFProduct.RPCResultLoadData(Connection: TsgcWSConnection; Id,
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
      StrToIntDef(QData.FieldByName('qty').AsString, 0),
      StrToFloatDef(QData.FieldByName('price').AsString, 0)
    );

    QData.Next;
  end;
end;

procedure TFProduct.RPCResultProccess(Connection: TsgcWSConnection; Id,
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
  tcMain.Previous;
  fnClear;

  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TFProduct.setFrame;
begin
  Self.Width := TControl(Self.Parent).Width;
  Self.Height := TControl(Self.Parent).Height;

  loTempViewData.Visible := False;
  fnClear;

  tcMain.TabIndex := 0;

  Self.Position.X := 0;
  Self.Position.Y := 0;

  Self.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];

  if FShow then
    Exit;

  FShow := True;

end;

end.
