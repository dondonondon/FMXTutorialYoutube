unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Layouts, FMX.Objects,
  FMX.ListBox, FMX.Edit, FMX.SearchBox, System.ImageList, FMX.ImgList, System.Generics.Collections;

type
  TFMain = class(TForm)
    mvMain: TMultiView;
    btnShow: TCornerButton;
    loMV: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Circle1: TCircle;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    Line1: TLine;
    SearchBox1: TSearchBox;
    btnMessage: TCornerButton;
    btnSettings: TCornerButton;
    SB: TStyleBook;
    img: TImageList;
    ListBoxItem1: TListBoxItem;
    btnDashboard: TCornerButton;
    ListBoxItem2: TListBoxItem;
    btnCustomers: TCornerButton;
    ListBoxItem3: TListBoxItem;
    btnPayments: TCornerButton;
    ListBoxItem4: TListBoxItem;
    btnAnalytics: TCornerButton;
    procedure btnShowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDashboardClick(Sender: TObject);
  private
    ListMenu : TList<TCornerButton>;
    procedure setMenu(B : TCornerButton); //ctrl + shift + c
  public

  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

procedure TFMain.btnDashboardClick(Sender: TObject);
begin
  setMenu(TCornerButton(Sender));
end;

procedure TFMain.btnShowClick(Sender: TObject);
begin
  mvMain.ShowMaster;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  ListMenu := TList<TCornerButton>.Create;
  ListMenu.Add(btnDashboard);
  ListMenu.Add(btnCustomers);
  ListMenu.Add(btnPayments);
  ListMenu.Add(btnAnalytics);
  ListMenu.Add(btnMessage);
  ListMenu.Add(btnSettings);
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  ListMenu.DisposeOf;
end;

procedure TFMain.setMenu(B: TCornerButton);
begin
  var LB : TCornerButton;
  for LB in ListMenu do begin
    LB.ImageIndex := LB.Tag;
    LB.StyleLookup := 'btnSidebarI';
    LB.Font.Style := [];
    LB.FontColor := $FF5E5E5E;
    LB.StyledSettings := [];
  end;

  B.ImageIndex := B.Tag + 1;
  B.Font.Style := [TFontStyle.fsBold];
  B.FontColor := $FFFFFFFF;
  B.StyleLookup := 'btnSidebarS';
end;

end.
