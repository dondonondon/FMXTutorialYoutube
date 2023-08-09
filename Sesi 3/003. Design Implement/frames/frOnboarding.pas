unit frOnboarding;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, System.Threading,
  FMX.TabControl, FMX.Effects;

type
  TFOnboarding = class(TFrame)
    loMain: TLayout;
    background: TRectangle;
    tcMain: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    btnNext: TCornerButton;
    seButton: TShadowEffect;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Image3: TImage;
    Label3: TLabel;
    procedure btnNextClick(Sender: TObject);
  private
    FShow : Boolean;
    procedure setFrame;
  public
  published
    procedure FirstShow;
    procedure fnGoBack;
  end;

var
  FOnboarding: TFOnboarding;

implementation

{$R *.fmx}

uses BFA.GoFrame, BFA.Env, BFA.Main, BFA.Func, BFA.Helper.Main,
  BFA.Helper.MemTable, BFA.OpenUrl, BFA.Rest, uDM, BFA.Helper.Control;

{ TFTemp }

procedure TFOnboarding.btnNextClick(Sender: TObject);
begin
  if tcMain.TabIndex = tcMain.TabCount - 1 then
    fnGoFrame(fromFrame, C_HOME)   //fnGoFrame(C_ONBOARDING, C_HOME)
  else
    tcMain.Next;
end;

procedure TFOnboarding.FirstShow;
begin       //procedure like event onShow
  setFrame;
end;

procedure TFOnboarding.fnGoBack;
begin
  fnBack;
end;

procedure TFOnboarding.setFrame;
begin
  Self.setAnchorContent;

  tcMain.TabIndex := 0;

  if FShow then
    Exit;

  FShow := True;

  //write code here => like event onCreate
end;

end.
