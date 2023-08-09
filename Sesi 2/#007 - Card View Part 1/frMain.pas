unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  System.ImageList, FMX.ImgList, FMX.Objects, FMX.Effects;

type
  TFMain = class(TForm)
    ListBox1: TListBox;
    gplMenu: TGridPanelLayout;
    CornerButton1: TCornerButton;
    SB: TStyleBook;
    img: TImageList;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    CornerButton4: TCornerButton;
    CornerButton5: TCornerButton;
    CornerButton6: TCornerButton;
    ListBoxItem1: TListBoxItem;
    Rectangle1: TRectangle;
    ListBoxItem2: TListBoxItem;
    Rectangle2: TRectangle;
    ListBoxItem3: TListBoxItem;
    Rectangle3: TRectangle;
    Image1: TImage;
    Layout1: TLayout;
    Rectangle4: TRectangle;
    ShadowEffect1: TShadowEffect;
    Label1: TLabel;
    ShadowEffect2: TShadowEffect;
    procedure ListBoxItem4Click(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

procedure TFMain.CornerButton1Click(Sender: TObject);
begin
  ShowMessage('Button');
end;

procedure TFMain.ListBoxItem4Click(Sender: TObject);
begin
  ShowMessage('');
end;

end.
