unit uViewHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TFHome = class(TFrame)
    Label1: TLabel;
    CornerButton1: TCornerButton;
    procedure CornerButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FHome : TFHome;

implementation

{$R *.fmx}

procedure TFHome.CornerButton1Click(Sender: TObject);
begin
  ShowMessage('INI ADALAH FRAME HOME');
end;

end.
