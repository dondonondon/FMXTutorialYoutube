unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
  TForm1 = class(TForm)
    vsMain: TVertScrollBox;
    loCustomData: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    lblKelas: TLabel;
    lblNama: TLabel;
    CornerButton1: TCornerButton;
    Rectangle2: TRectangle;
    procedure FormShow(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
  private
    YY : Single;

    procedure addItem(nama, kelas, AFileName : String); //ctrl + shift + c
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
begin
  lblNama.Text := nama;
  lblKelas.Text := kelas;

  Rectangle2.Fill.Bitmap.Bitmap.LoadFromFile(AFileName);

  lo := TLayout(loCustomData.Clone(vsMain));
  lo.Width := vsMain.Width - 32;
  lo.Position.X := 16;
  lo.Position.Y := YY;

  YY := YY + lo.Height + 12;

  lo.Visible := True;
  vsMain.AddObject(lo);
end;

procedure TForm1.CornerButton1Click(Sender: TObject);
var
  i: Integer;
begin
  vsMain.Content.DeleteChildren;
  YY := 12;

  for i := 0 to 10 do begin
    addItem('Blangkon FA ' + i.ToString, 'Custom Data', (Random(2) + 1).ToString + '.jpg');
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  loCustomData.Visible := False;
end;

end.
