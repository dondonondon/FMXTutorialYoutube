unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit,
  FMX.SearchBox;

type
  TForm1 = class(TForm)
    lbData: TListBox;
    loCustomData: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    lblKelas: TLabel;
    lblNama: TLabel;
    img: TImage;
    CornerButton1: TCornerButton;
    SearchBox1: TSearchBox;
    procedure FormCreate(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure imgClick(Sender: TObject);
  private
    procedure addItem(nama, kelas, AFileName : String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.addItem(nama, kelas, AFileName: String);
var
  lo : TLayout;
  lb : TListBoxItem;
begin
  lblNama.Text := nama;
  lblKelas.Text := kelas;

  if FileExists(AFileName) then
    img.Bitmap.LoadFromFile(AFileName);

  lb := TListBoxItem.Create(lbData);
  lb.Width := lbData.Width;
  lb.Height := loCustomData.Height + 12;
  lb.Selectable := False; //opsional
  lb.FontColor := $00FFFFFF; //opacity
  lb.Text := Format('%s %s', [nama, kelas]);
  lb.StyledSettings := [];

  lo := TLayout(loCustomData.Clone(lb));
  lo.Width := lb.Width - 32;
  lo.Position.X := 16;
  lo.Position.Y := 0;

  lo.Visible := True;

  TImage(lo.FindStyleResource('imgContoh')).OnClick := imgClick;

  lb.AddObject(lo);
  lbData.AddObject(lb);
end;

procedure TForm1.CornerButton1Click(Sender: TObject);
var
  i: Integer;
begin
  lbData.Items.Clear;

  for i := 0 to 20 do begin
    addItem('Blangkon FA ' + i.ToString, 'Custom Data ListBox', (Random(2) + 1).ToString + '.jpg');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  loCustomData.Visible := False;
end;

procedure TForm1.imgClick(Sender: TObject);
begin
  ShowMessage(TLabel(TLayout(TImage(Sender).Parent).FindStyleResource('lblNama')).Text);  
end;

end.
