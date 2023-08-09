unit frDetail;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TFDetail = class(TFrame)
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
  FDetail : TFDetail;

implementation

{$R *.fmx}

uses BFA.Main, BFA.Env;

{ TFTemp }

procedure TFDetail.FirstShow;
begin
  setFrame;
end;

procedure TFDetail.fnGoBack;
begin
  fnBack(procedure begin
    ShowMessage('this is procedure before go back');
  end);
end;

procedure TFDetail.Label1Click(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFDetail.setFrame;
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
