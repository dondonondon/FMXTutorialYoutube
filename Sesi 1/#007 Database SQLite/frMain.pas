unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Edit, FMX.SearchBox, System.Threading;

type
  TFMain = class(TForm)
    loMain: TLayout;
    tcMain: TTabControl;
    tiData: TTabItem;
    tiProsesData: TTabItem;
    lbMain: TListBox;
    loTemp: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblTempNama: TLabel;
    lblTempKelas: TLabel;
    lblTempHobi: TLabel;
    QData: TFDQuery;
    SearchBox1: TSearchBox;
    btnTambahData: TCornerButton;
    btnKembali: TCornerButton;
    edNama: TEdit;
    Label4: TLabel;
    edKelas: TEdit;
    Label5: TLabel;
    edHobi: TEdit;
    Label6: TLabel;
    btnProses: TCornerButton;
    btnHapus: TCornerButton;
    pbLoad: TProgressBar;
    lblProgres: TLabel;
    CornerButton1: TCornerButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnTambahDataClick(Sender: TObject);
    procedure btnKembaliClick(Sender: TObject);
    procedure btnProsesClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure lbMainItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure CornerButton1Click(Sender: TObject);
  private
    FJenis : String;
    procedure addItem(idx : Integer; nama, kelas, hobi : String);  //ctrl + Shift + C
    procedure loadData;
    procedure fnProses(jenis_proses : String);  //ctrl + Shift + C
    procedure fnClear;
    procedure fnSetPB(isVisible : Boolean);  //ctrl + Shift + C
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses uDM;

const
  TAMBAH = 'TAMBAH';
  HAPUS = 'HAPUS';
  UBAH = 'UBAH';

procedure TFMain.addItem(idx: Integer; nama, kelas, hobi: String);
var
  lb : TListBoxItem;
  lo : TLayout;
begin
  lblTempNama.Text := nama;
  lblTempKelas.Text := kelas;
  lblTempHobi.Text := hobi;

  lb := TListBoxItem.Create(lbMain);
  lb.Width := lbMain.Width;
  lb.Height := loTemp.Height + 8; //
  lb.Selectable := False;

  lb.Tag := idx;

  lb.Text := Format('%s %s %s', [nama, kelas, hobi]); //search data
  lb.FontColor := $00FFFFFF;
  lb.StyledSettings := [];

  lo := TLayout(loTemp.Clone(lb));
  lo.Width := lb.Width - 16;
  lo.Position.X := 8;
  lo.Position.Y := 0;

  lo.Visible := True;

  lb.AddObject(lo);
  lbMain.AddObject(lb);

end;

procedure TFMain.btnHapusClick(Sender: TObject);
begin
  if FJenis = TAMBAH then
    fnClear
  else
    fnProses(HAPUS);
end;

procedure TFMain.btnKembaliClick(Sender: TObject);
begin
  tcMain.Previous;
end;

procedure TFMain.btnProsesClick(Sender: TObject);
begin
  fnProses(FJenis);
end;

procedure TFMain.btnTambahDataClick(Sender: TObject);
begin
  fnClear;
  FJenis := TAMBAH;
  tcMain.Next;
end;

procedure TFMain.CornerButton1Click(Sender: TObject);
begin
  TTask.Run(procedure begin
    loadData;
  end).Start;
end;

procedure TFMain.fnClear;
begin
  edNama.Text := '';
  edKelas.Text := '';
  edHobi.Text := '';
  FJenis := '';
end;

procedure TFMain.fnProses(jenis_proses: String);
var
  SQLAdd : String;
begin
  try
    if jenis_proses = TAMBAH then begin
      SQLAdd := Format(
        'INSERT INTO tbl_biodata (nama, kelas, hobi) VALUES (''%s'', ''%s'', ''%s'')',
        [
          edNama.Text,
          edKelas.Text,
          edHobi.Text
        ]
      );
    end else if jenis_proses = UBAH then begin
      SQLAdd := Format(
        'UPDATE tbl_biodata SET nama = ''%s'', kelas = ''%s'', hobi = ''%s'' WHERE id = ''%s''',
        [
          edNama.Text,
          edKelas.Text,
          edHobi.Text,
          QData.FieldByName('id').AsString
        ]
      );
    end else if jenis_proses = HAPUS then begin
      SQLAdd := Format(
        'DELETE FROM tbl_biodata WHERE id = ''%s''',
        [
          QData.FieldByName('id').AsString
        ]
      );
    end else
      Exit;

    DM.Conn.StartTransaction;

    DM.QTemp1.Active := False;
    DM.QTemp1.Close;
    DM.QTemp1.SQL.Clear;
    DM.QTemp1.SQL.Text := SQLAdd;
    //DM.QTemp1.Active := True;
    DM.QTemp1.ExecSQL;

    loadData;

    tcMain.First;

    DM.Conn.Commit;
  except
    on E : Exception do begin
      ShowMessage(E.Message);
      DM.Conn.Rollback;
    end;
  end;
end;

procedure TFMain.fnSetPB(isVisible: Boolean);
begin
  TThread.Synchronize(nil, procedure begin
    pbLoad.Visible := isVisible;
    lbMain.Visible := not isVisible;

    if isVisible then begin
      lblProgres.Text := '0/0';
      pbLoad.Value := pbLoad.Min;
    end;
  end);
end;

procedure TFMain.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  loTemp.Visible := False;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  pbLoad.Visible := False;
  tcMain.TabIndex := 0;
  DM.Conn.Connected := True;
  TTask.Run(procedure begin
    Sleep(500);
    loadData;
  end).Start;

end;

procedure TFMain.lbMainItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  QData.RecNo := Item.Tag;

  edNama.Text := QData.FieldByName('nama').AsString;
  edKelas.Text := QData.FieldByName('kelas').AsString;
  edHobi.Text := QData.FieldByName('hobi').AsString;

  FJenis := UBAH;

  tcMain.Next;
end;

procedure TFMain.loadData;
var
  i: Integer;
begin
  fnSetPB(True);
  try
    try
      lbMain.Items.Clear;

      QData.Active := False;
      QData.SQL.Clear;
      QData.SQL.Text := 'SELECT * FROM tbl_biodata';
      QData.Active := True;
      QData.Open;

      if QData.IsEmpty then begin
        ShowMessage('Tidak ada data!');
        Exit;
      end;

      TThread.Synchronize(nil, procedure begin
        pbLoad.Min := 0;
        pbLoad.Max := QData.RecordCount;
      end);

      for i := 0 to QData.RecordCount - 1 do begin
        TThread.Synchronize(nil, procedure begin
          addItem(QData.RecNo,
            QData.FieldByName('nama').AsString,
            QData.FieldByName('kelas').AsString,
            QData.FieldByName('hobi').AsString
          );

          pbLoad.Value := QData.RecNo;
          lblProgres.Text := pbLoad.Value.ToString + '/' + pbLoad.Max.ToString;
        end);

        Sleep(10);

        QData.Next;
      end;

    except
      on E : Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
    fnSetPB(False);
  end;
end;

end.
