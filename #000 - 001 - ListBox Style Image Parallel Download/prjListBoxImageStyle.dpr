program prjListBoxImageStyle;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {FMain},
  BFA.Func in 'sources\BFA.Func.pas',
  BFA.Helper.Control in 'sources\BFA.Helper.Control.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
