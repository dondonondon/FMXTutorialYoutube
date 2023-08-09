unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.ImageList, FMX.ImgList,
  FMX.Layouts
  {$IF DEFINED (ANDROID)}
  , Androidapi.JNI.GraphicsContentViewText
  , Androidapi.Helpers
  {$ENDIF}
  ;

type
  TFMain = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CornerButton1: TCornerButton;
    SB: TStyleBook;
    imgList: TImageList;
    CornerButton2: TCornerButton;
    Label4: TLabel;
    FlowLayout1: TFlowLayout;
    Glyph1: TGlyph;
    Glyph2: TGlyph;
    Glyph3: TGlyph;
    Label5: TLabel;
    Layout1: TLayout;
    procedure FormShow(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses frHome;

procedure TFMain.CornerButton2Click(Sender: TObject);
begin
  FHome.Show;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  TAndroidHelper.Activity.getWindow.setFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_LAYOUT_NO_LIMITS,
    TJWindowManager_LayoutParams.JavaClass.FLAG_LAYOUT_NO_LIMITS
  );
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  Label3.Text :=
    'Best cloud storage platform for all '#13 +
    'business and individuals to '#13 +
    'manage there data  '#13#13 +
    'Join For Free.';
end;

end.
