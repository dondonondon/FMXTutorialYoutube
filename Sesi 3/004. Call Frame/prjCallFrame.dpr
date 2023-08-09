program prjCallFrame;

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {FMain},
  BFA.GoFrame in 'sources\BFA.GoFrame.pas',
  frLoading in 'frames\frLoading.pas' {FLoading: TFrame},
  BFA.Main in 'sources\BFA.Main.pas',
  frLogin in 'frames\frLogin.pas' {FLogin: TFrame},
  frHome in 'frames\frHome.pas' {FHome: TFrame},
  BFA.Env in 'sources\BFA.Env.pas',
  frDetail in 'frames\frDetail.pas' {FDetail: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
