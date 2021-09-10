unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.TabControl, FMX.Edit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Net.Mime;

type
  TFMain = class(TForm)
    tcMain: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    btnRefresh: TCornerButton;
    stgData: TStringGrid;
    btnTambahData: TCornerButton;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    edKelas: TEdit;
    Label1: TLabel;
    edHobi: TEdit;
    Label2: TLabel;
    edNama: TEdit;
    Label3: TLabel;
    btnHapus: TCornerButton;
    btnSimpan: TCornerButton;
    memData: TFDMemTable;
    btnKembali: TCornerButton;
    procedure btnTambahDataClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure stgDataCellClick(const Column: TColumn; const Row: Integer);
    procedure btnKembaliClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
  private
    FTransID : String;
    FProses : String;
    procedure fnClearStringGrid(FStringGrid : TStringGrid); //ctrl + shift + c
    procedure fnLoadData; //ctrl + shift + c
    procedure fnInsertItem; //ctrl + shift + c
    procedure fnUpdateItem; //ctrl + shift + c
    procedure fnDeleteItem; //ctrl + shift + c
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses BFA.Helper.MemTable;

const
  CTAMBAH = 'TAMBAH';
  CUBAH = 'UBAH';

procedure TFMain.btnHapusClick(Sender: TObject);
begin
  fnDeleteItem;
end;

procedure TFMain.btnKembaliClick(Sender: TObject);
begin
  FTransID := '';
  tcMain.Previous;
end;

procedure TFMain.btnRefreshClick(Sender: TObject);
begin
  fnLoadData;
end;

procedure TFMain.btnSimpanClick(Sender: TObject);
begin
  if FProses = CUBAH then
    fnUpdateItem
  else if FProses = CTAMBAH then
    fnInsertItem;
end;

procedure TFMain.btnTambahDataClick(Sender: TObject);
begin
  FProses := CTAMBAH;

  edKelas.Text := '';
  edHobi.Text := '';
  edNama.Text := '';

  tcMain.Next;
end;

procedure TFMain.fnClearStringGrid(FStringGrid: TStringGrid);
begin
  for var i := 0 to FStringGrid.ColumnCount - 1 do
    for var ii := 0 to FStringGrid.RowCount - 1 do
      FStringGrid.Cells[i, ii] := '';

  FStringGrid.RowCount := 0;
end;

procedure TFMain.fnDeleteItem;
var
  par : TMultipartFormData;
begin
  par := TMultipartFormData.Create();
  try
    par.AddField('tbl', 'tbl_data');
    par.AddField('id', FTransID);

    if not memData.FillDataFromURL('http://localhost/Tutorial/APICrud/APICrud.php?act=deleteItem', par) then begin
      ShowMessage(memData.FieldByName('pesan').AsString);
      Exit;
    end;

    edKelas.Text := '';
    edNama.Text := '';
    edHobi.Text := '';

    fnLoadData;

    tcMain.Previous;

  finally
    par.DisposeOf;
  end;
end;

procedure TFMain.fnInsertItem;
var
  par : TMultipartFormData;
begin
  par := TMultipartFormData.Create();
  try

    fnClearStringGrid(stgData);

    par.AddField('tbl', 'tbl_data');
    par.AddField('kol', 'nama, kelas, hobi');
    par.AddField('val', Format('''%s'', ''%s'', ''%s''',
      [
        edNama.Text, edKelas.Text, edHobi.Text
      ]
    ));
    par.AddField('isWhere', 'nama = ' + QuotedStr(edNama.Text) + 'AND kelas = ' + QuotedStr(edKelas.Text));

    if not memData.FillDataFromURL('http://localhost/Tutorial/APICrud/APICrud.php?act=insertItemIsNull', par) then begin
      ShowMessage('Gagal Insert Data');
      Exit;
    end;

    edKelas.Text := '';
    edNama.Text := '';
    edHobi.Text := '';

    fnLoadData;

    tcMain.Previous;

  finally
    par.DisposeOf;
  end;
end;

procedure TFMain.fnLoadData;
var
  par : TMultipartFormData;
begin
  par := TMultipartFormData.Create();
  try

    fnClearStringGrid(stgData);

    par.AddField('tbl', 'tbl_data');
    par.AddField('val', '*');
    par.AddField('isWhere', '');
    par.AddField('order', 'ORDER BY cdt DESC');
    par.AddField('limit', '10');

    if not memData.FillDataFromURL('http://localhost/Tutorial/APICrud/APICrud.php?act=loadItem', par) then begin
      ShowMessage('Gagal Ambil Data');
      Exit;
    end;

    stgData.RowCount := memData.RecordCount;

    for var i := 0 to memData.RecordCount - 1 do begin
      stgData.Cells[0, i] := memData.FieldByName('nama').AsString;
      stgData.Cells[1, i] := memData.FieldByName('kelas').AsString;
      stgData.Cells[2, i] := memData.FieldByName('hobi').AsString;
      stgData.Cells[3, i] := memData.FieldByName('id').AsString;

      memData.Next;
    end;

  finally
    par.DisposeOf;
  end;
end;

procedure TFMain.fnUpdateItem;
var
  par : TMultipartFormData;
begin
  par := TMultipartFormData.Create();
  try

    fnClearStringGrid(stgData);

    par.AddField('tbl', 'tbl_data');
    par.AddField('val', Format('nama = ''%s'', kelas = ''%s'', hobi = ''%s''',
      [
        edNama.Text, edKelas.Text, edHobi.Text
      ]
    ));
    par.AddField('isWhere', 'id = ' + QuotedStr(FTransID));

    if not memData.FillDataFromURL('http://localhost/Tutorial/APICrud/APICrud.php?act=updateItem', par) then begin
      ShowMessage('Gagal Ubah Data');
      Exit;
    end;

    edKelas.Text := '';
    edNama.Text := '';
    edHobi.Text := '';

    fnLoadData;

    tcMain.Previous;

  finally
    par.DisposeOf;
  end;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  tcMain.TabIndex := 0;
end;

procedure TFMain.stgDataCellClick(const Column: TColumn; const Row: Integer);
begin
  FProses := CUBAH;

  FTransID := stgData.Cells[3, Row];
  edNama.Text := stgData.Cells[0, Row];
  edKelas.Text := stgData.Cells[1, Row];
  edHobi.Text := stgData.Cells[2, Row];

  tcMain.Next;
end;

end.
