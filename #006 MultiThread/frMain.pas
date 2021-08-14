unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls, System.Threading,
  FMX.Objects, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
  TForm1 = class(TForm)
    CornerButton1: TCornerButton;
    Memo1: TMemo;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    CornerButton4: TCornerButton;
    Image1: TImage;
    nHTTP: TNetHTTPClient;
    AniIndicator1: TAniIndicator;
    procedure CornerButton1Click(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
    procedure CornerButton3Click(Sender: TObject);
    procedure CornerButton4Click(Sender: TObject);
  private
    procedure DownloadImage(URL : String);
    procedure loading(isEnable : Boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.CornerButton1Click(Sender: TObject);
begin
  Sleep(1000);
  memo1.Lines.Add('Halo Tanpa Thread');
end;

procedure TForm1.CornerButton2Click(Sender: TObject);
begin
  TThread.CreateAnonymousThread(procedure begin
    Sleep(1000);
    TThread.Synchronize(TThread.CurrentThread, procedure begin
      memo1.Lines.Add('Dengan CreateAnonymousThread')
    end);
  end).Start;
end;

procedure TForm1.CornerButton3Click(Sender: TObject);
//https://www.harapanrakyat.com/wp-content/uploads/2021/02/Sinopsis-Kuroko-No-Basket-Season-2.jpg
begin
  TTask.Run(procedure begin
    Sleep(1000);
    TThread.Synchronize(TThread.CurrentThread, procedure begin
      memo1.Lines.Add('Dengan TTaskRun')
    end);
  end).Start;
end;

procedure TForm1.CornerButton4Click(Sender: TObject);
begin
  TTask.Run(procedure begin
    loading(True);
    try
      DownloadImage(Memo1.Text);
    finally
      loading(False);
    end;
  end).Start;
end;

procedure TForm1.DownloadImage(URL : String);
var
  Stream : TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    nHTTP.Get(URL, Stream);
    TThread.Synchronize(TThread.CurrentThread, procedure begin
      Image1.Bitmap.LoadFromStream(Stream);
    end);
  finally
    Stream.DisposeOf; //FREE
  end;
end;

procedure TForm1.loading(isEnable: Boolean);
begin
  TThread.Synchronize(TThread.CurrentThread, procedure begin
    AniIndicator1.Enabled := isEnable;
  end);
end;

end.
