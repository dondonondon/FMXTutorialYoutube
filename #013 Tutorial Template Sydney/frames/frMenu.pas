unit frMenu;
interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Objects;
type
  TFMenu = class(TFrame)
    loMain: TLayout;
    Label1: TLabel;
    CornerButton1: TCornerButton;
    Rectangle1: TRectangle;
    procedure FirstShow;
    procedure CornerButton1Click(Sender: TObject);
  private
    statF : Boolean;
    procedure setFrame;
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;
var
  FMenu : TFMenu;
implementation
{$R *.fmx}
uses BFA.Func, BFA.GoFrame, BFA.Helper.Control, BFA.Helper.Main, BFA.Main,
  BFA.OpenUrl, BFA.Rest, frHome, uDM;
{ TFTemp }
const
  spc = 10;
  pad = 8;
procedure TFMenu.CornerButton1Click(Sender: TObject);
begin
  //fnGoFrame(C_MENU, C_HOME, True);
  fnBack(procedure begin
    FHome.CornerButton1.Text := 'Ini Di Ganti';
  end);
end;

procedure TFMenu.FirstShow;
begin
  setFrame;
  CornerButton1.Text := 'Ganti Melalui FirstShow';

end;
procedure TFMenu.fnGoBack;
begin
  fnGoFrame(GoFrame, FromFrame);
end;
procedure TFMenu.ReleaseFrame;
begin
  DisposeOf;
end;
procedure TFMenu.setFrame;
begin
  Self.setAnchorContent;
  if statF then
    Exit;
  statF := True;
end;
end.
