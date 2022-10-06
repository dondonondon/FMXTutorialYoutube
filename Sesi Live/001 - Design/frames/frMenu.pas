unit frMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, System.Threading,
  FMX.Edit, FMX.ListBox, FMX.SearchBox;

type
  TFMenu = class(TFrame)
    loMain: TLayout;
    background: TRectangle;
    loItemMenu: TLayout;
    loDetailOrder: TLayout;
    btnMenu: TCornerButton;
    btnFilter: TCornerButton;
    edSearch: TEdit;
    btnSearch: TCornerButton;
    Rectangle1: TRectangle;
    hsCategory: THorzScrollBox;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    CornerButton4: TCornerButton;
    CornerButton5: TCornerButton;
    CornerButton6: TCornerButton;
    CornerButton7: TCornerButton;
    lbMenu: TListBox;
    loCardViewItem: TLayout;
    reBackgroundCardView: TRectangle;
    reBackgroundCardViewImage: TRectangle;
    imgCardView: TImage;
    lblPrice: TLabel;
    lblName: TLabel;
    sbMenu: TSearchBox;
    procedure btnMenuClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
  private
    FShow : Boolean;
    procedure setFrame;
    procedure addCardView(FName, FPrice : String);
  public
  published
    procedure FirstShow;
    procedure fnGoBack;
  end;

var
  FMenu: TFMenu;

implementation

{$R *.fmx}

uses BFA.GoFrame, BFA.Env, BFA.Main, BFA.Func, BFA.Helper.Main,
  BFA.Helper.MemTable, BFA.OpenUrl, BFA.Rest, uDM, BFA.Helper.Control, frMain;

{ TFTemp }

procedure TFMenu.addCardView(FName, FPrice: String);
begin
  var lb := TListBoxItem.Create(lbMenu);
  lb.Selectable := False;
  lb.Width := lbMenu.Width / lbMenu.Columns;
  lb.Height := loCardViewItem.Height + 8;

  lb.Text := FName;
  lb.FontColor := $00FFFFFF;
  lb.StyledSettings := [];

  var lo := TLayout(loCardViewItem.Clone(lb));
  lo.Width := lb.Width - 8;
  lo.Position.X := 4;
  lo.Position.Y := 4;

  lo.Visible := True;

  TLabel(lo.FindStyleResource(lblName.StyleName)).Text := FName;
  TLabel(lo.FindStyleResource(lblPrice.StyleName)).Text := '$' + FPrice + '.00';

  var FImageName : String;

  {$IF DEFINED (MSWINDOWS)}
  var FLocation := 'D:\Job\Tutorial\Youtube Live\001 - Design\assets\images\products\';
  FImageName := FLocation + Random(5).ToString + '.png';
  {$ELSEIF DEFINED (ANDROID)}
  FImageName := fnLoadFile(Random(5).ToString + '.png');
  {$ENDIF}

  if FileExists(FImageName) then
    TImage(lo.FindStyleResource(imgCardView.StyleName)).Bitmap.LoadFromFile(FImageName);

  lb.AddObject(lo);
  lbMenu.AddObject(lb);

  lo.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];
end;

procedure TFMenu.btnMenuClick(Sender: TObject);
begin
  FMain.mvMain.ShowMaster;
end;

procedure TFMenu.btnSearchClick(Sender: TObject);
begin
  sbMenu.Text := edSearch.Text;
end;

procedure TFMenu.FirstShow;
begin       //procedure like event onShow
  setFrame;

  if lbMenu.Items.Count > 0 then
    Exit;

  for var i := 0 to 15 do begin
    addCardView('Nama Barang Ke ' + i.ToString, Random(100).toString);
  end;
end;

procedure TFMenu.fnGoBack;
begin
  fnBack;
end;

procedure TFMenu.setFrame;
begin
  Self.setAnchorContent;

  loCardViewItem.Visible := False;

  FMain.setMenu(FMain.btnMenu);

  if FShow then
    Exit;

  FShow := True;

  //write code here => like event onCreate
end;

end.
