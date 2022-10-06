unit frProses;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Objects,
  FMX.Edit, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.Effects
  , System.Permissions, FMX.DialogService, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.MediaLibrary.Actions, REST.Types;

type
  TFProses = class(TFrame)
    loMain: TLayout;
    background: TRectangle;
    btnBack: TCornerButton;
    Label1: TLabel;
    edNIP: TEdit;
    edNama: TEdit;
    Label2: TLabel;
    edKelas: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edNotelp: TEdit;
    Label5: TLabel;
    edHobi: TEdit;
    Label6: TLabel;
    memAlamat: TMemo;
    btnProses: TCornerButton;
    btnDelete: TCornerButton;
    lbMain: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    CornerButton1: TCornerButton;
    img: TImage;
    reHeader: TRectangle;
    ShadowEffect1: TShadowEffect;
    OD: TOpenDialog;
    AL: TActionList;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure CornerButton1Click(Sender: TObject);
    procedure btnProsesClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    statF : Boolean;
    FTransID : String;
    FPermissionRead, FPermissionWrite : String;
    procedure fnClear;
    procedure setFrame;
    procedure fnInsertItem; //ctrl + shift + c
    procedure fnUpdateItem; //ctrl + shift + c
    procedure fnDeleteItem; //ctrl + shift + c
    function fnUploadFiles(FLokasi : String) : Boolean;  //ctrl + shift + c
    procedure DisplayRationale(Sender : TObject; const APermissions : TArray<String>; const APostRationaleProc : TProc);
    procedure RequestPermissionResult(Sender : TObject; const
      APermissions : TArray<String>; const AGrantResults : TArray<TPermissionStatus>);    //ctrl + Shift + c
  public
    FJenis : Integer; {0 = INSERT, 1 = UPDATE, 2 = DELETE}
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FProses : TFProses;

implementation

{$R *.fmx}

uses BFA.Func, BFA.GoFrame, BFA.Helper.Control, BFA.Helper.Main, BFA.Main,
  BFA.OpenUrl, BFA.Rest, uDM, System.IOUtils, frDetail;

{ TFTemp }

const
  spc = 10;
  pad = 8;



procedure TFProses.btnBackClick(Sender: TObject);
begin
  fnBack;
end;

procedure TFProses.btnDeleteClick(Sender: TObject);
begin
  TTask.Run(procedure begin
    fnDeleteItem;
  end).Start;
end;

procedure TFProses.btnProsesClick(Sender: TObject);
begin
  if edNIP.Text = '' then begin
    fnShowMessage('NIP TIDAK BOLEH KOSONG');
    Exit;
  end;

  if edNama.Text = '' then begin
    fnShowMessage('NAMA TIDAK BOLEH KOSONG');
    Exit;
  end;

  if edKelas.Text = '' then begin
    fnShowMessage('KELAS TIDAK BOLEH KOSONG');
    Exit;
  end;

  if edNotelp.Text = '' then begin
    fnShowMessage('NOMOR TELEPON TIDAK BOLEH KOSONG');
    Exit;
  end;

  if edHobi.Text = '' then begin
    fnShowMessage('HOBI TIDAK BOLEH KOSONG');
    Exit;
  end;

  if memAlamat.Text = '' then begin
    fnShowMessage('ALAMAT TIDAK BOLEH KOSONG');
    Exit;
  end;

  TTask.Run(procedure begin
    if FJenis = 0 then
      fnInsertItem
    else if FJenis = 1 then
      fnUpdateItem;
  end).Start;

end;

procedure TFProses.CornerButton1Click(Sender: TObject);
begin
  {$IF DEFINED (MSWINDOWS)}
    OD.FileName := '';
    OD.Filter := 'File Gambar | *.png;*.jpg;*.bmp;*.jpeg';
    OD.Execute;

    if OD.FileName = '' then
      Exit;

    img.Bitmap.LoadFromFile(OD.FileName);
    img.Bitmap.SaveToFile(fnLoadFile('temp.png'));
  {$ELSEIF DEFINED(ANDROID)}
    PermissionsService.RequestPermissions(
      [FPermissionWrite, FPermissionRead],
      RequestPermissionResult, DisplayRationale
    );
  {$ENDIF}
end;

procedure TFProses.DisplayRationale(Sender: TObject;
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

procedure TFProses.FirstShow;
begin
  setFrame;

  if FJenis = 1 then begin
    with FDetail do begin
      edNIP.Text := memData.FieldByName('nip').AsString;
      edNama.Text := memData.FieldByName('nama').AsString;
      edKelas.Text := memData.FieldByName('kelas').AsString;
      edNotelp.Text := memData.FieldByName('notelp').AsString;
      edHobi.Text := memData.FieldByName('hobi').AsString;
      memAlamat.Lines.Add(memData.FieldByName('alamat').AsString);
      FTransID := memData.FieldByName('id_siswa').AsString;

      img.LoadFromLoc(memData.FieldByName('nip').AsString +
        FormatDateTime('yyyymmddhhnnss', memData.FieldByName('udt').AsDateTime) + '.png')
    end;
  end;
end;

procedure TFProses.fnClear;
begin
  edNIP.Text := '';
  edNama.Text := '';
  edNotelp.Text := '';
  edKelas.Text := '';
  edHobi.Text := '';

  img.Bitmap := nil;

  memAlamat.Lines.Clear;
end;

procedure TFProses.fnDeleteItem;
var
  req : String;
begin
  req := 'deleteItemWhere';
  DM.RReq.AddParameter('tbl', 'tb_siswa');
  DM.RReq.AddParameter('isWhere', 'id_siswa = ' + QuotedStr(FTransID));

  if not fnParsingJSON(req, DM.memData) then begin
    fnShowMessage(DM.memData.FieldByName('pesan').AsString);
    Exit;
  end;

  fnShowMessage('Data berhasil di hapus');
  TThread.Synchronize(nil, procedure begin
    fnBack;
  end);
end;

procedure TFProses.fnGoBack;
begin
  fnGoFrame(GoFrame, FromFrame);
end;

procedure TFProses.fnInsertItem;
var
  req : String;
begin
  if not fnUploadFiles(fnLoadFile('temp.png')) then begin
    fnShowMessage('GAMBAR GAGAL DI UPLOAD, SILAHKAN ULANGI LAGI');
    Exit;
  end;

  req := 'insertItemIsNull';
  DM.RReq.AddParameter('tbl', 'tb_siswa');
  DM.RReq.AddParameter('kol', 'nip, nama, kelas, alamat, notelp, hobi');
  DM.RReq.AddParameter('val', Format(
    '''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s''',
    [
      edNIP.Text, edNama.Text, edKelas.Text, memAlamat.Text, edNotelp.Text, edHobi.Text
    ]
  ));
  DM.RReq.AddParameter('isWhere', 'nip = ' +QuotedStr(edNIP.Text));

  if not fnParsingJSON(req, DM.memData) then begin
    fnShowMessage(DM.memData.FieldByName('pesan').AsString);
    Exit;
  end;

  fnShowMessage('Data berhasil di tambah');
  TThread.Synchronize(nil, procedure begin
    fnBack;
  end);
end;

procedure TFProses.fnUpdateItem;
var
  req : String;
begin
  if not fnUploadFiles(fnLoadFile('temp.png')) then begin
    fnShowMessage('GAMBAR GAGAL DI UPLOAD, SILAHKAN ULANGI LAGI');
    Exit;
  end;

  req := 'updateItem';
  DM.RReq.AddParameter('tbl', 'tb_siswa');
  DM.RReq.AddParameter('val', Format(
    'nip = ''%s'', nama = ''%s'', kelas = ''%s'', notelp = ''%s'', hobi = ''%s'', alamat = ''%s'', udt = ''%s''',
    [
      edNIP.Text, edNama.Text, edKelas.Text, edNotelp.Text, edHobi.Text, memAlamat.Text,
      FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)
    ]
  ));
  DM.RReq.AddParameter('isWhere', 'id_siswa = ' +QuotedStr(FTransID));

  if not fnParsingJSON(req, DM.memData) then begin
    fnShowMessage(DM.memData.FieldByName('pesan').AsString);
    Exit;
  end;

  fnShowMessage('Data berhasil di ubah');
  TThread.Synchronize(nil, procedure begin
    fnBack;
  end);
end;

function TFProses.fnUploadFiles(FLokasi: String): Boolean;
var
  req : String;
begin
  Result := False;

  req := 'uploadFiles';
  DM.RReq.AddParameter('nmFile', edNIP.Text + '.png');
  DM.RReq.AddFile('fileToUpload', FLokasi, TRESTContentType.ctMULTIPART_FORM_DATA);

  if not fnParsingJSON(req, DM.memData) then
    Result := False
  else
    Result := True;
end;

procedure TFProses.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFProses.RequestPermissionResult(Sender: TObject;
  const APermissions: TArray<String>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 2) AND (AGrantResults[0] = TPermissionStatus.Granted) AND (AGrantResults[1] = TPermissionStatus.Granted) then begin
    TakePhotoFromLibraryAction1.Execute;
  end else begin
    TDialogService.ShowMessage('gagal mendapatkan akses storeage');
  end;
end;

procedure TFProses.setFrame;
begin
  Self.setAnchorContent;
  fnClear;

  lbMain.ViewportPosition := Point(0, 0);

  if statF then
    Exit;

  statF := True;

end;

procedure TFProses.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
begin
  img.Bitmap := Image;
  img.Bitmap.SaveToFile(fnLoadFile('temp.png'));
end;

end.
