unit frLoading;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TFLoading = class(TFrame)
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
  FLoading : TFLoading;

implementation

{$R *.fmx}

uses BFA.Main, BFA.Env;

{ TFTemp }

procedure TFLoading.FirstShow;
begin
  setFrame;
end;

procedure TFLoading.fnGoBack;
begin
  fnBack;
end;

procedure TFLoading.Label1Click(Sender: TObject);
begin
  fnGoFrame(goFrame, C_LOGIN);
end;

procedure TFLoading.setFrame;
begin
  Self.Width := TControl(Self.Parent).Width;
  Self.Height := TControl(Self.Parent).Height;

  Self.Position.X := 0;
  Self.Position.Y := 0;

  Self.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];
  //Self.Align := TAlignLayout.Contents;

  if FShow then
    Exit;

  FShow := True;

end;

end.
