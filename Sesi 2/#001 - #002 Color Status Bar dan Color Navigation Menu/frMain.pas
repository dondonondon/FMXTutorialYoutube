unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Androidapi.Helpers,
  FMX.Controls.Presentation, FMX.StdCtrls, Androidapi.JNI.GraphicsContentViewText;

type
  TFMain = class(TForm)
    Label1: TLabel;
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

procedure TFMain.FormCreate(Sender: TObject);
begin
  //TAndroidHelper.Activity.getWindow.setStatusBarColor($FF0978CA);
  //TAndroidHelper.Activity.getWindow.setNavigationBarColor($FF0978CA);
  TAndroidHelper.Activity.getWindow.setFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_LAYOUT_NO_LIMITS,
    TJWindowManager_LayoutParams.JavaClass.FLAG_LAYOUT_NO_LIMITS
  );
end;

end.
