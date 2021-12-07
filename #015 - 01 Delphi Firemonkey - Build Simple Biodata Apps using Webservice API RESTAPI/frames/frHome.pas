unit frHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Objects,
  FMX.Edit, FMX.ListBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFHome = class(TFrame)
    loMain: TLayout;
    lbMain: TListBox;
    background: TRectangle;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    loTemp: TLayout;
    reTemp: TRectangle;
    lblTempKelas: TLabel;
    lblTempJumlah: TLabel;
    memData: TFDMemTable;
    btnTambah: TCornerButton;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
    procedure lbMainItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    statF : Boolean;
    procedure setFrame;
    procedure addItem(FIndex : Integer; FKelas, FTotal : String);  //ctrl + Shift + C
    procedure fnLoadData;  //ctrl + Shift + C
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FHome : TFHome;

implementation

{$R *.fmx}

uses BFA.Func, BFA.GoFrame, BFA.Helper.Control, BFA.Helper.Main, BFA.Main,
  BFA.OpenUrl, BFA.Rest, frMain, uDM, frDetail;


{ TFTemp }

const
  spc = 10;
  pad = 8;

procedure TFHome.addItem(FIndex : Integer; FKelas, FTotal: String);
var
  lb : TListBoxItem;
  lo : TLayout;
begin
  lblTempKelas.Text := FKelas;
  lblTempJumlah.Text := FTotal + ' Siswa';

  lb := TListBoxItem.Create(nil);
  lb.Selectable := False;
  lb.Width := lbMain.Width / lbMain.Columns;
  lb.Height := lbMain.Width / lbMain.Columns;
  lb.Tag := FIndex;

  lb.Hint := FKelas;

  lo := TLayout(loTemp.Clone(nil));
  lo.Width := lb.Width - 8;
  lo.Height := lb.Height - 8;
  lo.Position.X := 4;
  lo.Position.Y := 4;

  lo.Visible := True;

  lb.AddObject(lo);
  lbMain.AddObject(lb);
end;

procedure TFHome.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFHome.CornerButton1Click(Sender: TObject);
begin
  fnGoFrame(C_HOME, C_DETAIL);
end;

procedure TFHome.CornerButton2Click(Sender: TObject);
begin
  fnBack;
end;

procedure TFHome.FirstShow;
begin
  setFrame;
  TTask.Run(procedure begin
    Sleep(CIdle);
    fnLoadData;
  end).Start;
end;

procedure TFHome.fnGoBack;
begin
  fnGoFrame(GoFrame, FromFrame);
end;

procedure TFHome.fnLoadData;
var
  req : String;
begin
  try
    req := 'getDataGroupKelas';

    if not fnParsingJSON(req, memData) then begin
      fnShowMessage(memData.FieldByName('pesan').AsString);
      Exit;
    end;

    TThread.Synchronize(nil, procedure begin
      lbMain.Items.Clear;
      if not memData.IsEmpty then begin
        for var i := 0 to memData.RecordCount - 1 do begin
          //FIndex : Integer; FKelas, FTotal: String
          addItem(
            memData.RecNo,
            memData.FieldByName('kelas').AsString,
            memData.FieldByName('total_data').AsString
          );
          memData.Next;
        end;
      end;
    end);
  finally

  end;
end;

procedure TFHome.lbMainItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  FDetail.FTransKelas := Item.Hint;
  fnGoFrame(C_HOME, C_DETAIL);
end;

procedure TFHome.Rectangle1Click(Sender: TObject);
begin
  fnGoFrame(C_HOME, C_DETAIL);
end;

procedure TFHome.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFHome.setFrame;
begin
  Self.setAnchorContent;

  loTemp.Visible := False;

  if statF then
    Exit;

  statF := True;

end;

end.
