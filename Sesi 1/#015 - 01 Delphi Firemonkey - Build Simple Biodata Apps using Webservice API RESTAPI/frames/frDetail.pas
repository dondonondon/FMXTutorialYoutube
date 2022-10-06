unit frDetail;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Objects,
  System.Actions, FMX.ActnList, FMX.TabControl, FMXTee.Series, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, FMX.Ani, FMX.ImgList, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.ListBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFDetail = class(TFrame)
    loMain: TLayout;
    background: TRectangle;
    lbMain: TListBox;
    loTemp: TLayout;
    reTempBackground: TRectangle;
    reTempImage: TRectangle;
    lblTempNIP: TLabel;
    lblTempNama: TLabel;
    lblTempKelas: TLabel;
    lblTempNotelp: TLabel;
    memData: TFDMemTable;
    btnTambah: TCornerButton;
    procedure FirstShow;
    procedure btnTambahClick(Sender: TObject);
  private
    statF : Boolean;
    procedure setFrame;
    procedure addItem(FIndex : Integer; FNIP, FNama, FKelas, FNotelp, FUDT : String); //ctrl + shift + c
    procedure fnLoadData; //ctrl + shift + c
  public
    FTransKelas : String;
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FDetail : TFDetail;

implementation

{$R *.fmx}

uses BFA.Func, BFA.GoFrame, BFA.Helper.Control, BFA.Helper.Main, BFA.Main,
  BFA.OpenUrl, BFA.Rest, uDM;

{ TFTemp }

const
  spc = 10;
  pad = 8;

procedure TFDetail.addItem(FIndex: Integer; FNIP, FNama, FKelas,
  FNotelp, FUDT: String);
var
  lb : TListBoxItem;
  lo : TLayout;
begin
  lblTempNIP.Text := FNIP;
  lblTempNama.Text := FNama;
  lblTempKelas.Text := FKelas;
  lblTempNotelp.Text := FNotelp;

  if FileExists(fnLoadFile(FNIP + FUDT + '.png')) then begin
    reTempImage.LoadFromLoc(FNIP + FUDT + '.png');
  end else begin
    fnShowMessage('No Image');
  end;

  lb := TListBoxItem.Create(nil);
  lb.Selectable := False;
  lb.Width := lbMain.Width;
  lb.Height := loTemp.Height + 16;
  lb.Tag := FIndex;

  lo := TLayout(loTemp.Clone(nil));
  lo.Width := lb.Width - 16;
  lo.Position.X := 8;
  lo.Position.Y := 8;

  lo.Visible := True;

  lb.AddObject(lo);
  lbMain.AddObject(lb);
end;

procedure TFDetail.btnTambahClick(Sender: TObject);
begin
  fnBack();
end;

procedure TFDetail.FirstShow;
begin
  setFrame;
  TTask.Run(procedure begin
    Sleep(CIdle);
    fnLoadData;
  end).Start;
end;

procedure TFDetail.fnGoBack;
begin
  fnGoFrame(GoFrame, FromFrame);
end;

procedure TFDetail.fnLoadData;
var
  req, FNamaImage : String;
begin
  try
    req := 'getData';
    DM.RReq.AddParameter('tbl', 'tb_siswa');
    DM.RReq.AddParameter('val', '*');
    DM.RReq.AddParameter('isWhere', 'kelas = ' + QuotedStr(FTransKelas));
    DM.RReq.AddParameter('order', 'ORDER BY nip DESC');
    DM.RReq.AddParameter('limit', '1000');

    if not fnParsingJSON(req, memData) then begin
      fnShowMessage(memData.FieldByName('pesan').AsString);
      Exit;
    end;

    memData.First;
    for var i := 0 to memData.RecordCount - 1 do begin
      FNamaImage := memData.FieldByName('nip').AsString +
        FormatDateTime('yyyymmddhhnnss', memData.FieldByName('udt').AsDateTime) + '.png';
      if not FileExists(fnLoadFile(FNamaImage)) then begin
        fnDownloadFile(
          assURL + memData.FieldByName('nip').AsString + '.png',
          FNamaImage
        );
      end;
      memData.Next;
    end;

    TThread.Synchronize(nil, procedure begin
      lbMain.Items.Clear;
      if not memData.IsEmpty then begin
        memData.First;

        for var i := 0 to memData.RecordCount - 1 do begin
          //FIndex : Integer; FNIP, FNama, FKelas, FNotelp, FUDT : String
          addItem(
            memData.RecNo,
            memData.FieldByName('nip').AsString,
            memData.FieldByName('nama').AsString,
            memData.FieldByName('kelas').AsString,
            memData.FieldByName('notelp').AsString,
            FormatDateTime('yyyymmddhhnnss', memData.FieldByName('udt').AsDateTime)
          );
          memData.Next;
        end;
      end;
    end);
  finally

  end;
end;

procedure TFDetail.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFDetail.setFrame;
begin
  Self.setAnchorContent;

  loTemp.Visible := False;
  lbMain.Items.Clear;

  if statF then
    Exit;

  statF := True;

end;

end.
