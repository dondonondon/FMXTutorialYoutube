unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, System.ImageList, FMX.ImgList,
  FMX.TabControl, FMX.Edit;

type
  TFMain = class(TForm)
    loFrame: TLayout;
    SB: TStyleBook;
    img: TImageList;
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

uses BFA.Env, BFA.GoFrame, BFA.Main, BFA.Websocket, uDM;

procedure TFMain.FormCreate(Sender: TObject);
begin
  //
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  FListGo.DisposeOf;
  LListFrame.DisposeOf;
  WebSocket.DisposeOf;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  WebSocket := WSConnect.Create;
  WebSocket.Protocol := DM.wsProtocol;
  WebSocket.Client := DM.wsClient;

  CreateFrame;
  fnGoFrame('', C_LOADING);
end;

end.
