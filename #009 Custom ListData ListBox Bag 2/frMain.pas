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
    lblJumlah: TLabel;
    btnTambah: TCornerButton;
    btnKurang: TCornerButton;
    CornerButton2: TCornerButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure imgClick(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
  private
    procedure addItem(nama, kelas, AFileName : String; Jumlah : Integer);
    procedure fnTambahKurang(Sender : TObject); //shift + ctrl + C
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.addItem(nama, kelas, AFileName: String; Jumlah : Integer);
var
  lo : TLayout;
  lb : TListBoxItem;
begin
  lblNama.Text := nama;
  lblKelas.Text := kelas;
  lblJumlah.Text := Jumlah.ToString;

  if FileExists(AFileName) then
    img.Bitmap.LoadFromFile(AFileName);

  lb := TListBoxItem.Create(lbData);
  lb.Width := lbData.Width;
  lb.Height := loCustomData.Height + 12;
  lb.Selectable := False; //opsional
  lb.FontColor := $00FFFFFF; //opacity
  lb.Text := Format('%s %s', [nama, kelas]);
  lb.ItemData.Detail := nama;
  lb.StyledSettings := [];

  lo := TLayout(loCustomData.Clone(lb));
  lo.Width := lb.Width - 32;
  lo.Position.X := 16;
  lo.Position.Y := 0;

  lo.Visible := True;
  lo.StyleName := 'loTemp';

  TImage(lo.FindStyleResource('imgContoh')).OnClick := imgClick;

  TCornerButton(lo.FindStyleResource('btnTambah')).OnClick := fnTambahKurang;
  TCornerButton(lo.FindStyleResource('btnKurang')).OnClick := fnTambahKurang;

  lb.AddObject(lo);
  lbData.AddObject(lb);
end;

procedure TForm1.CornerButton1Click(Sender: TObject);
const
  arr : array[0..2] of String = ('Jeruk', 'Apel', 'Mangga');

var
  i: Integer;
begin
  lbData.Items.Clear;

  for i := 0 to Length(arr) - 1 do begin
    addItem(arr[i], 'Custom Data ListBox', (Random(2) + 1).ToString + '.jpg', 1);
  end;
end;

procedure TForm1.CornerButton2Click(Sender: TObject);
var
  lo : TLayout;
  i, ii: Integer;
begin
  for i := 0 to lbData.Items.Count - 1 do begin
    if LowerCase(lbData.ListItems[i].ItemData.Detail) = LowerCase(Edit1.Text) then begin
      //query update
      for ii := 0 to lbData.ListItems[i].ControlsCount - 1 do
        if lbData.ListItems[i].Controls[ii] is TLayout then
          if TLayout(lbData.ListItems[i].Controls[ii]).StyleName = 'loTemp' then
            lo := TLayout(lbData.ListItems[i].Controls[ii]);

      TLabel(lo.FindStyleResource('lblJumlah')).Text := (StrToIntDef(TLabel(lo.FindStyleResource('lblJumlah')).Text, 1) + StrToIntDef(Edit2.Text, 1)).ToString;
      Exit;
    end;
  end;

  //query insert
  addItem(Edit1.Text, 'Custom Data ListBox', (Random(2) + 1).ToString + '.jpg', StrToIntDef(Edit2.Text, 1));
end;

procedure TForm1.fnTambahKurang(Sender: TObject);
var
  B : TCornerButton;
  lo : TLayout;
  L : TLabel;

  val : Integer;
begin
  B := TCornerButton(Sender);
  lo := TLayout(B.Parent);
  L := TLabel(lo.FindStyleResource('lblJumlah'));

  val := StrToIntDef(L.Text, 1);
  val := val + B.Tag;

  if val = 0 then begin
    lbData.ListItems[TListBoxItem(lo.Parent).Index].DisposeOf;
    //query delete
  end else begin
    //query update
    L.Text := val.ToString;
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
