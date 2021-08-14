unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ImgList,
  System.ImageList, FMX.Layouts;

type
  TFMain = class(TForm)
    tcMain: TTabControl;
    tiLogin: TTabItem;
    tiRegister: TTabItem;
    bg_login: TImage;
    bg_register: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    btnLogin: TCornerButton;
    Label4: TLabel;
    Label5: TLabel;
    SB: TStyleBook;
    Glyph1: TGlyph;
    img: TImageList;
    Glyph2: TGlyph;
    Label6: TLabel;
    Edit3: TEdit;
    Glyph3: TGlyph;
    Edit4: TEdit;
    Glyph4: TGlyph;
    Edit5: TEdit;
    Glyph5: TGlyph;
    Edit6: TEdit;
    Glyph6: TGlyph;
    Label7: TLabel;
    CornerButton1: TCornerButton;
    Label8: TLabel;
    flSocial: TFlowLayout;
    Image1: TImage;
    Image2: TImage;
    CornerButton2: TCornerButton;
    loMain: TLayout;
    procedure Label5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

procedure TFMain.CornerButton2Click(Sender: TObject);
begin
  tcMain.Previous;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  tcMain.TabIndex := 0;
end;

procedure TFMain.Label5Click(Sender: TObject);
begin
  tcMain.Next;
end;

end.
