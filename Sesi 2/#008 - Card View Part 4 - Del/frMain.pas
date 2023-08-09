unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Objects, FMX.Effects, FMX.StdCtrls, FMX.Controls.Presentation,
  REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.Threading,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TFMain = class(TForm)
    loHeader: TLayout;
    lbProduct: TListBox;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    loCard: TLayout;
    reCardBackground: TRectangle;
    reCardImage: TRectangle;
    seCard: TShadowEffect;
    lblCardNama: TLabel;
    lblCardHarga: TLabel;
    lblCardBrand: TLabel;
    lblCardStok: TLabel;
    btnCardKeranjang: TCornerButton;
    SB: TStyleBook;
    Label1: TLabel;
    CornerButton1: TCornerButton;
    ShadowEffect1: TShadowEffect;
    RClient: TRESTClient;
    RReq: TRESTRequest;
    RResp: TRESTResponse;
    RRDataAdapter: TRESTResponseDataSetAdapter;
    QData: TFDMemTable;
    aIndicator: TAniIndicator;
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure lbProductViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
  private
    arrRect : array of TRectangle;
    procedure addItem(FIndex : Integer; FNama, FBrand: String; FStok: Integer; FHarga : Single; FImage : String); //ctrl + shift + c
    procedure fnLoadData;
    procedure fnIndicator(FStat : Boolean); //ctr; + shift + c
    procedure fnDownload(FURL, FNama : String);   //ctr; + shift + c
    procedure fnSetImage(FIndex : Integer); //ctrl + shift + c
    procedure fnFillData(FTotal : Integer); //ctr ////
  public

  end;

var
  FMain: TFMain;

const
  FLoc = 'D:\Job\Tutorial\Youtube #2\#008 - Card View Part 2\assets\images\';

implementation

{$R *.fmx}

{ TFMain }

uses
  System.IOUtils;

procedure TFMain.addItem(FIndex : Integer; FNama, FBrand: String; FStok: Integer; FHarga : Single; FImage : String);
begin
  var lb := TListBoxItem.Create(nil);
  lb.Selectable := False;
  lb.Width := lbProduct.Width / 2;
  lb.Height := loCard.Height + 12;

  var lo := TLayout(loCard.Clone(nil));
  lo.Width := lb.Width - 8;
  lo.Position.X := 4;
  lo.Position.Y := 8;

  lo.Visible := True;

  TLabel(lo.FindStyleResource('lblCardNama')).Text := FNama;
  TLabel(lo.FindStyleResource('lblCardHarga')).Text := 'Rp ' + FormatFloat('###,##0.00', FHarga);
  TLabel(lo.FindStyleResource('lblCardBrand')).Text := FBrand;
  TLabel(lo.FindStyleResource('lblCardStok')).Text := FStok.ToString + ' pcs';

  {$IF DEFINED (ANDROID)}
  //var FLocAndroid := TPath.GetDocumentsPath + '/' + FImage;
  //TRectangle(lo.FindStyleResource('reCardImage')).Fill.Bitmap.Bitmap.LoadFromFile(FLocAndroid);
  {$ELSEIF DEFINED (MSWINDOWS)}
  //TRectangle(lo.FindStyleResource('reCardImage')).Fill.Bitmap.Bitmap.LoadFromFile(FLoc + FImage);
  {$ENDIF}

  arrRect[FIndex - 1] := TRectangle(lo.FindStyleResource('reCardImage'));
  TRectangle(lo.FindStyleResource('reCardImage')).Hint := FImage;

  lb.AddObject(lo);
  lbProduct.AddObject(lb);
end;

procedure TFMain.CornerButton1Click(Sender: TObject);
begin
  //ShowMessage(ExpandFileName(GetCurrentDir) + PathDelim ); Exit;

  lbProduct.Items.Clear;

  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TFMain.fnDownload(FURL, FNama: String);
begin
  var FHTTP : TNetHTTPClient;
  var FStream : TMemoryStream;

  FHTTP := TNetHTTPClient.Create(nil);
  try
    FStream := TMemoryStream.Create;
    try
      FHTTP.Get(FURL, FStream);
      {$IF DEFINED (ANDROID)}
      FStream.SaveToFile(TPath.GetDocumentsPath + PathDelim + FNama);
      {$ELSEIF DEFINED (MSWINDOWS)}
      FStream.SaveToFile(ExpandFileName(GetCurrentDir) + PathDelim + FNama);
      {$ENDIF}
    finally
      FStream.DisposeOf;
    end;
  finally
    FHTTP.DisposeOf;
  end;
end;

procedure TFMain.fnFillData(FTotal: Integer);
var
  FEvent : TPositionChangeEvent;
  tempRecord, tempTotalRecord : Integer;
begin

  if lbProduct.Items.Count >= QData.RecNo then
    Exit;

  //fnIndicator(True);
  try

    lbProduct.OnViewportPositionChange := nil;

    tempRecord := QData.RecNo - 1;

    TThread.Synchronize(nil, procedure begin
      lbProduct.BeginUpdate;
      try
        for var i := 0 to FTotal - 1 do begin
          addItem(QData.RecNo,
            QData.FieldByName('nama_produk').AsString,
            QData.FieldByName('brand').AsString,
            QData.FieldByName('stok').AsInteger,
            QData.FieldByName('harga').AsFloat,
            QData.FieldByName('gambar_1').AsString
          );

          QData.Next;

          if QData.RecordCount = QData.RecNo then
            Break;

          Memo1.Lines.Add(tempRecord.ToString + ',' + QData.RecNo.ToString);
        end;

      finally
        lbProduct.EndUpdate;
      end;
    end);

    tempTotalRecord := QData.RecNo - 1;

  finally
    lbProduct.OnViewportPositionChange := lbProductViewportPositionChange;
    //fnIndicator(False);

    TParallel.For(tempRecord, tempTotalRecord, procedure (i : Integer) begin
      fnSetImage(i);
    end);


    {for var ii := tempRecord to tempTotalRecord do
      fnSetImage(ii); }
  end;
end;

procedure TFMain.fnIndicator(FStat: Boolean);
begin
  TThread.Synchronize(nil, procedure begin
    aIndicator.Enabled := FStat;
    aIndicator.Visible := FStat;
  end);
end;

procedure TFMain.fnLoadData;
begin
  fnIndicator(True);
  try
    RResp.RootElement := '';
    RReq.Execute;

    RResp.RootElement := 'data';

    SetLength(arrRect, QData.RecordCount);
    QData.First;

    var FLoad : Integer;
    FLoad := Round(lbProduct.Height / (loCard.Height + 12)) * 4;

    fnFillData(6);
  finally
    fnIndicator(False);
  end;
end;

procedure TFMain.fnSetImage(FIndex: Integer);
begin
  TThread.Synchronize(nil, procedure begin
    Memo1.Lines.Add(FIndex.ToString + '. ' + arrRect[FIndex].Hint);
  end);
  fnDownload(
    arrRect[FIndex].Hint,
    (FIndex).ToString + '.png'
  );

  TThread.Synchronize(nil, procedure begin
    {$IF DEFINED (ANDROID)}
    var FLoc := (TPath.GetDocumentsPath + PathDelim + (FIndex).ToString + '.png');
    {$ELSEIF DEFINED (MSWINDOWS)}
    var FLoc := (ExpandFileName(GetCurrentDir) + PathDelim + (FIndex).ToString + '.png');
    {$ENDIF}



    arrRect[FIndex].Fill.Bitmap.Bitmap.LoadFromFile(FLoc);
  end);
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  var FormatBr : TFormatSettings;
  FormatBr := TFormatSettings.Create;
  FormatBr.DecimalSeparator := '.';
  FormatBr.ThousandSeparator := ',';

  System.SysUtils.FormatSettings := FormatBr;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  loCard.Visible := False;
  //fnLoadData;
end;

procedure TFMain.lbProductViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
begin

  label1.text := (Round(lbProduct.ViewportPosition.Y + 0.4999).ToString + ',' +
  lbProduct.ContentBounds.Size.cy.ToString + ',' +
  (lbProduct.ContentBounds.Size.cy - lbProduct.Height).ToString
  );
  if Round(lbProduct.ViewportPosition.Y + 0.4999) >= (lbProduct.ContentBounds.Size.cy - lbProduct.Height) then begin
    if lbProduct.Items.Count >= QData.RecNo then
      Exit;

    TTask.Run(procedure begin
      fnFillData(6);
    end).Start;
  end;
end;

end.
