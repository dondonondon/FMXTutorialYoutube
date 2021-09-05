program prjParsingJSONRestClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
