unit frTemp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Effects, FMX.Controls.Presentation;

type
  TFTemp = class(TFrame)
    background: TRectangle;
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    loMain: TLayout;
    btnBack: TCornerButton;
    lblTitle: TLabel;
    procedure btnBackClick(Sender: TObject);
  private
    FShow : Boolean;
    procedure setFrame;
  public
  published
    procedure FirstShow;  //ctrl + Shift + C
    procedure fnGoBack;
  end;

var
  FTemp : TFTemp;

implementation

{$R *.fmx}

uses BFA.Main, BFA.Env, BFA.Func, frMain, uDM;

{ TFTemp }

procedure TFTemp.btnBackClick(Sender: TObject);
begin
  fnBack;
end;

procedure TFTemp.FirstShow;
begin
  setFrame;
end;

procedure TFTemp.fnGoBack;
begin
  fnBack;
end;

procedure TFTemp.setFrame;
begin
  Self.Width := TControl(Self.Parent).Width;
  Self.Height := TControl(Self.Parent).Height;

  Self.Position.X := 0;
  Self.Position.Y := 0;

  Self.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];

  if FShow then
    Exit;

  FShow := True;

end;

end.
