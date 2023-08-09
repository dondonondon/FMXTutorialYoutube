unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, System.ImageList, FMX.ImgList,
  FMX.Objects, FMX.Effects, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.TreeView;

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
    tcMain: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    Label3: TLabel;
    Label4: TLabel;
    AL: TActionList;
    ChangeTabAction1: TChangeTabAction;
    ChangeTabAction2: TChangeTabAction;
    ChangeTabAction3: TChangeTabAction;
    ChangeTabAction4: TChangeTabAction;
    procedure CornerButton1Click(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure setMenu(B : TCornerButton); //Ctrl + shift + c
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses uViewHome, uViewSearch;

{ TFMain }

procedure TFMain.CornerButton1Click(Sender: TObject);
begin
  setMenu(TCornerButton(Sender));

  if not Assigned(FHome) then begin
    FHome := TFHome.Create(Self);
    FHome.Align := TAlignLayout.Client;

    TabItem1.AddObject(FHome);
  end;

  var TabIndex := StrToIntDef(TCornerButton(Sender).Hint, 0);
  AL.Actions[TabIndex].Execute;

end;

procedure TFMain.CornerButton2Click(Sender: TObject);
begin
  setMenu(TCornerButton(Sender));

  if not Assigned(FSearch) then begin
    FSearch := TFSearch.Create(Self);
    FSearch.Align := TAlignLayout.Client;

    TabItem2.AddObject(FSearch);
  end;

  var TabIndex := StrToIntDef(TCornerButton(Sender).Hint, 0);
  AL.Actions[TabIndex].Execute;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  if not Assigned(FHome) then begin
    FHome := TFHome.Create(Self);
    FHome.Align := TAlignLayout.Client;

    TabItem1.AddObject(FHome);
  end;
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
