unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Objects, FMX.Effects, FMX.StdCtrls, FMX.Controls.Presentation,
  REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

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
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
  private
    procedure addItem(FNama, FBrand: String; FStok: Integer; FHarga : Single; FImage : String); //ctrl + shift + c
    procedure fnLoadData;
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

procedure TFMain.addItem(FNama, FBrand: String; FStok: Integer; FHarga : Single; FImage : String);
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
  var FLocAndroid := TPath.GetDocumentsPath + '/' + FImage;
  TRectangle(lo.FindStyleResource('reCardImage')).Fill.Bitmap.Bitmap.LoadFromFile(FLocAndroid);
  {$ELSEIF DEFINED (MSWINDOWS)}
  TRectangle(lo.FindStyleResource('reCardImage')).Fill.Bitmap.Bitmap.LoadFromFile(FLoc + FImage);
  {$ENDIF}

  lb.AddObject(lo);
  lbProduct.AddObject(lb);
end;

procedure TFMain.CornerButton1Click(Sender: TObject);
begin
  fnLoadData;
end;

procedure TFMain.fnLoadData;
begin
  lbProduct.Items.Clear;
  lbProduct.BeginUpdate;
  try
    for var i := 0 to 20 do begin

      addItem(
        'Sepatu Bata L' + Random(10).ToString,
        'Bata Indonesia',
        Random(100),
        Random(100000) + 10000,
        (Random(10) + 1).ToString + '.png'
      );

    end;
  finally
    lbProduct.EndUpdate;
  end;
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

end.
