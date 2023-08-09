unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, System.ImageList, FMX.ImgList,
  FMX.Objects, FMX.Effects;

type
  TFMain = class(TForm)
    loFooter: TLayout;
    gplMenu: TGridPanelLayout;
    CornerButton1: TCornerButton;
    img: TImageList;
    SB: TStyleBook;
    reMenu: TRectangle;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    CornerButton4: TCornerButton;
    seFooter: TShadowEffect;
    seMenu: TShadowEffect;
    procedure CornerButton1Click(Sender: TObject);
  private
    procedure setMenu(B : TCornerButton); //Ctrl + shift + c
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

{ TFMain }

procedure TFMain.CornerButton1Click(Sender: TObject);
begin
  setMenu(TCornerButton(Sender));
end;

procedure TFMain.setMenu(B: TCornerButton);
begin
  for var i := 0 to gplMenu.ControlsCount - 1 do begin
    if TControl(gplMenu.Controls[i]) is TCornerButton then begin
      TCornerButton(gplMenu.Controls[i]).ImageIndex := TCornerButton(gplMenu.Controls[i]).Tag;
      TCornerButton(gplMenu.Controls[i]).FontColor := $FFDADADA;
      TCornerButton(gplMenu.Controls[i]).Font.Style := [];
      TCornerButton(gplMenu.Controls[i]).StyledSettings := [];
    end;
  end;

  B.ImageIndex := B.Tag - 1;
  B.FontColor := $FF6499FB;
  B.Font.Style := [TFontStyle.fsBold];
end;

end.
