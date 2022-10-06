unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.TabControl, FMX.Edit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Net.Mime, FMX.Objects, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, System.Permissions, FMX.DialogService,
  System.Actions, FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions
  {$IF DEFINED (ANDROID)}
   ,Androidapi.Helpers, FMX.Helpers.Android, Androidapi.Jni.Os
  {$ENDIF}
  ;

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
    imgFoto: TImage;
    btnPilihFoto: TCornerButton;
    OD: TOpenDialog;
    StringColumn5: TStringColumn;
    AL: TActionList;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    procedure btnTambahDataClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure stgDataCellClick(const Column: TColumn; const Row: Integer);
    procedure btnKembaliClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure btnPilihFotoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
  private
    FTransID : String;
    FProses : String;
    FNamaFile : String;
    FPermissionRead, FPermissionWrite : String;
    procedure fnClearStringGrid(FStringGrid : TStringGrid); //ctrl + shift + c
    procedure fnLoadData; //ctrl + shift + c
    procedure fnInsertItem; //ctrl + shift + c
    procedure fnUpdateItem; //ctrl + shift + c
    procedure fnDeleteItem; //ctrl + shift + c
    function fnUploadFiles(FLokasi : String) : Boolean;  //ctrl + shift + c
    procedure fnDownloadFile(FURL, nmFile : String); //ctrl + shift + c
                                                                                        //ctrl + shift + c
    procedure DisplayRationale(Sender : TObject; const APermissions : TArray<String>; const APostRationaleProc : TProc);
    procedure RequestPermissionResult(Sender : TObject; const APermissions : TArray<String>; const AGrantResults : TArray<TPermissionStatus>);
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses BFA.Helper.MemTable, System.IOUtils;

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

procedure TFMain.btnPilihFotoClick(Sender: TObject);
begin
  {$IF DEFINED (MSWINDOWS)}
    OD.FileName := '';
    OD.Filter := 'File Gambar | *.png;*.jpg;*.bmp;*.jpeg';
    OD.Execute;

    if OD.FileName = '' then
      Exit;

    imgFoto.Bitmap.LoadFromFile(OD.FileName);
    imgFoto.Bitmap.SaveToFile('temp.png');
  {$ELSEIF DEFINED(ANDROID)}
    PermissionsService.RequestPermissions(
      [FPermissionWrite, FPermissionRead],
      RequestPermissionResult, DisplayRationale
    );
  {$ENDIF}
end;

procedure TFMain.btnRefreshClick(Sender: TObject);
begin
  fnLoadData;
end;

procedure TFMain.btnSimpanClick(Sender: TObject);
begin
  imgFoto.Bitmap.SaveToFile(TPath.GetDocumentsPath + PathDelim + 'temp.png');

  if fnUploadFiles(TPath.GetDocumentsPath + PathDelim + 'temp.png') then begin
    if FProses = CUBAH then
      fnUpdateItem
    else if FProses = CTAMBAH then
      fnInsertItem;
  end;
end;

procedure TFMain.btnTambahDataClick(Sender: TObject);
begin
  FProses := CTAMBAH;

  edKelas.Text := '';
  edHobi.Text := '';
  edNama.Text := '';

  tcMain.Next;
end;

procedure TFMain.DisplayRationale(Sender: TObject;
  const APermissions: TArray<String>; const APostRationaleProc: TProc);
var
  RationaleMsg : String;
begin
  for var i := 0 to High(APermissions) do begin
    if APermissions[i] = FPermissionRead then
      RationaleMsg := RationaleMsg + 'Applikasi meminta ijin membaca storage'#13
    else if APermissions[i] = FPermissionWrite then
      RationaleMsg := RationaleMsg + 'Aplikasi meminta ijin menulis storage';
  end;

  TDialogService.ShowMessage(RationaleMsg, procedure(const AResult : TModalResult) begin
    APostRationaleProc;
  end);
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

    if not memData.FillDataFromURL('http://192.168.100.45/Tutorial/APICrud/APICrud.php?act=deleteItem', par) then begin
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

procedure TFMain.fnDownloadFile(FURL, nmFile: String);
var
  nHTTPS : TNetHTTPClient;
  Stream : TMemoryStream;
begin
  nHTTPS := TNetHTTPClient.Create(nil);
  try
    Stream := TMemoryStream.Create;
    try
      try
        nHTTPS.Get(FURL, Stream);
        {$IF DEFINED(ANDROID)}
          Stream.SaveToFile(TPath.GetDocumentsPath + PathDelim + nmFile);
        {$ELSEIF DEFINED(MSWINDOWS)}
          Stream.SaveToFile(nmFile);
        {$ENDIF}
      except
        ShowMessage('Data Gagal Di Download');
      end;
    finally
      Stream.DisposeOf;
    end;
  finally
    nHTTPS.DisposeOf;
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
    par.AddField('kol', 'nama, kelas, hobi, nmFile');
    par.AddField('val', Format('''%s'', ''%s'', ''%s'', ''%s''',
      [
        edNama.Text, edKelas.Text, edHobi.Text, FNamaFile
      ]
    ));
    par.AddField('isWhere', 'nama = ' + QuotedStr(edNama.Text) + 'AND kelas = ' + QuotedStr(edKelas.Text));

    if not memData.FillDataFromURL('http://192.168.100.45/Tutorial/APICrud/APICrud.php?act=insertItemIsNull', par) then begin
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

    if not memData.FillDataFromURL('http://192.168.100.45/Tutorial/APICrud/APICrud.php?act=loadItem', par) then begin
      ShowMessage(memData.FieldByName('pesan').AsString);
      Exit;
    end;

    stgData.RowCount := memData.RecordCount;

    for var i := 0 to memData.RecordCount - 1 do begin
      fnDownloadFile(
        'http://192.168.100.45/Tutorial/APICrud/files/' + memData.FieldByName('nmFile').AsString,
        memData.FieldByName('nmFile').AsString
      );

      stgData.Cells[0, i] := memData.FieldByName('nama').AsString;
      stgData.Cells[1, i] := memData.FieldByName('kelas').AsString;
      stgData.Cells[2, i] := memData.FieldByName('hobi').AsString;
      stgData.Cells[3, i] := memData.FieldByName('id').AsString;
      stgData.Cells[4, i] := memData.FieldByName('nmFile').AsString;

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
    par.AddField('val', Format('nama = ''%s'', kelas = ''%s'', hobi = ''%s'', nmFile = ''%s''',
      [
        edNama.Text, edKelas.Text, edHobi.Text, FNamaFile
      ]
    ));
    par.AddField('isWhere', 'id = ' + QuotedStr(FTransID));

    if not memData.FillDataFromURL('http://192.168.100.45/Tutorial/APICrud/APICrud.php?act=updateItem', par) then begin
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

function TFMain.fnUploadFiles(FLokasi: String): Boolean;
var
  par : TMultipartFormData;
begin
  par := TMultipartFormData.Create();
  try
    if FProses = CTAMBAH then
      FNamaFile := FormatDateTime('yyyymmddhhnnss', Now) + (Random(1000).ToString) + ExtractFileExt(FLokasi);

    par.AddFile('fileToUpload', FLokasi);
    par.AddField('nmFile', FNamaFile);

    if not memData.FillDataFromURL('http://192.168.100.45/Tutorial/APICrud/APICrud.php?act=uploadFiles', par) then begin
      ShowMessage(memData.FieldByName('pesan').AsString);
      Result := False;
    end else begin
      Result := True;
    end;

  finally
    par.DisposeOf;
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  {$IF DEFINED (ANDROID)}
    FPermissionRead := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
    FPermissionWrite := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
  {$ENDIF}
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  tcMain.TabIndex := 0;
end;

procedure TFMain.RequestPermissionResult(Sender: TObject;
  const APermissions: TArray<String>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 2) AND (AGrantResults[0] = TPermissionStatus.Granted) AND (AGrantResults[1] = TPermissionStatus.Granted) then begin
    TakePhotoFromLibraryAction1.Execute;
  end else begin
    TDialogService.ShowMessage('gagal mendapatkan akses storeage');
  end;
end;

procedure TFMain.stgDataCellClick(const Column: TColumn; const Row: Integer);
begin
  FProses := CUBAH;

  FTransID := stgData.Cells[3, Row];
  edNama.Text := stgData.Cells[0, Row];
  edKelas.Text := stgData.Cells[1, Row];
  edHobi.Text := stgData.Cells[2, Row];

  FNamaFile := stgData.Cells[4, Row];

    {$IF DEFINED(ANDROID)}
    if FileExists(TPath.GetDocumentsPath + PathDelim + FNamaFile) then
      imgFoto.Bitmap.LoadFromFile(TPath.GetDocumentsPath + PathDelim + FNamaFile);
    {$ELSEIF DEFINED(MSWINDOWS)}
    if FileExists(FNamaFile) then
      imgFoto.Bitmap.LoadFromFile(FNamaFile);
    {$ENDIF}

  tcMain.Next;
end;

procedure TFMain.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
begin
  imgFoto.Bitmap := Image;
  imgFoto.Bitmap.SaveToFile(TPath.GetDocumentsPath + PathDelim + 'temp.png');
end;

end.
