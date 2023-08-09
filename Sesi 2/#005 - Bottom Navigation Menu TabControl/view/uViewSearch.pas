unit uViewSearch;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TFSearch = class(TFrame)
    Label1: TLabel;
    CornerButton1: TCornerButton;
    procedure CornerButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSearch : TFSearch;

implementation

{$R *.fmx}

procedure TFSearch.CornerButton1Click(Sender: TObject);
begin
  ShowMessage('INI ADALAH FRAME SEARCH');
end;

end.
