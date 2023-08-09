program prjBottomNavigasi;

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {FMain},
  uViewHome in 'view\uViewHome.pas' {FHome: TFrame},
  uViewSearch in 'view\uViewSearch.pas' {FSearch: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
