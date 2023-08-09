unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts;

type
  TFMain = class(TForm)
    loFrame: TLayout;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses BFA.Env, BFA.GoFrame, BFA.Main;

procedure TFMain.FormCreate(Sender: TObject);
begin
  //
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  FListGo.DisposeOf;
  LListFrame.DisposeOf;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  CreateFrame;
  fnGoFrame('', C_LOADING);
end;

end.
