program prjParallelFor;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {Form1},
  BFA.Func in 'sources\BFA.Func.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
