program prjDirbbox;

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {FMain},
  frHome in 'frHome.pas' {FHome};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFHome, FHome);
  Application.Run;
end.
