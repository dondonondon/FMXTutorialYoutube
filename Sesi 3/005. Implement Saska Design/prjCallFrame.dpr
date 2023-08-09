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
  frDetail in 'frames\frDetail.pas' {FDetail: TFrame},
  uDM in 'uDM.pas' {DM: TDataModule},
  BFA.Func in 'sources\BFA.Func.pas',
  BFA.Helper.Main in 'BFA.Helper.Main.pas',
  BFA.Websocket in 'sources\BFA.Websocket.pas',
  BFA.Helper.MemTable in 'sources\BFA.Helper.MemTable.pas',
  frProduct in 'frames\frProduct.pas' {FProduct: TFrame},
  frTransaction in 'frames\frTransaction.pas' {FTransaction: TFrame};

{$R *.res}

begin

  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
