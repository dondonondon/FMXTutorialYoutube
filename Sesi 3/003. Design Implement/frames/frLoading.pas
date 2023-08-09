unit frLoading;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Effects, FMX.Ani, System.Threading;

type
  TFLoading = class(TFrame)
    loMain: TLayout;
    background: TRectangle;
    logo: TImage;
    Image1: TImage;
    ShadowEffect2: TShadowEffect;
    Image2: TImage;
    ShadowEffect3: TShadowEffect;
    Image3: TImage;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    tiMove: TTimer;
    faOpa: TFloatAnimation;
    AniIndicator1: TAniIndicator;
    procedure tiMoveTimer(Sender: TObject);
    procedure faOpaFinish(Sender: TObject);
  private
    FShow : Boolean;
    procedure setFrame;
  public
  published
    procedure FirstShow;
    procedure fnGoBack;
  end;

var
  FLoading: TFLoading;

implementation

{$R *.fmx}

uses BFA.GoFrame, BFA.Env, BFA.Main, BFA.Func, BFA.Helper.Main,
  BFA.Helper.MemTable, BFA.OpenUrl, BFA.Rest, uDM, BFA.Helper.Control;

{ TFLoading }

procedure TFLoading.faOpaFinish(Sender: TObject);
begin
  TFloatAnimation(Sender).Enabled := False;
  tiMove.Enabled := True;
end;

procedure TFLoading.FirstShow;
begin
  setFrame;
  loMain.Visible := False;
  TTask.Run(procedure begin
    Sleep(Round(Helper.getIdle * 1.5));
    TThread.Synchronize(TThread.CurrentThread, procedure begin
      Self.setAnchorContent;
      loMain.Opacity := 0;
      loMain.Visible := True;
      faOpa.Enabled := True;
    end);
  end).Start;
end;

procedure TFLoading.fnGoBack;
begin       //procedure like event onShow
  fnBack;
end;

procedure TFLoading.setFrame;
begin
  Self.setAnchorContent;

  if FShow then
    Exit;

  FShow := True;

  //write code here => like event onCreate
end;

procedure TFLoading.tiMoveTimer(Sender: TObject);
begin
  tiMove.Enabled := False;
  fnGoFrame(C_LOADING, C_ONBOARDING);
end;

end.