unit frLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TFLogin = class(TFrame)
    Label1: TLabel;
    procedure Label1Click(Sender: TObject);
  private
    FShow : Boolean;
    procedure setFrame;
  public
  published
    procedure FirstShow;  //ctrl + Shift + C
    procedure fnGoBack;
  end;

var
  FLogin : TFLogin;

implementation

{$R *.fmx}

uses BFA.Main, BFA.Env;

{ TFTemp }

procedure TFLogin.FirstShow;
begin
  setFrame;
end;

procedure TFLogin.fnGoBack;
begin
  fnBack;
end;

procedure TFLogin.Label1Click(Sender: TObject);
begin
  fnGoFrame(goFrame, C_HOME);
end;

procedure TFLogin.setFrame;
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
