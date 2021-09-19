unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  System.ImageList, FMX.ImgList, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid,FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListBox, FMX.Ani, System.Threading,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Memo, FMX.Edit, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  {$IFDEF ANDROID}
    Androidapi.Helpers, FMX.Platform.Android, System.Android.Service, System.IOUtils,
    FMX.Helpers.Android, Androidapi.JNI.PlayServices, Androidapi.JNI.Os,
  {$ELSEIF Defined(MSWINDOWS)}
    {IWSystem,}
  {$ENDIF}
  System.Generics.Collections, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, FMX.LoadingIndicator;

type
  TFMain = class(TForm)
    lbData: TListBox;
    SB: TStyleBook;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    OD: TOpenDialog;
    btnLoad: TCornerButton;
    edCount: TEdit;
    Layout1: TLayout;
    Layout2: TLayout;
    pbProgress: TProgressBar;
    lblCount: TLabel;
    tiCount: TTimer;
    procedure btnLoadClick(Sender: TObject);
    procedure tiCountTimer(Sender: TObject);
  private
    FProses : Boolean;
    FLoad : Integer;
    procedure fnLoadData;
    procedure addItem(FName, FURL : String);
    procedure fnDownloadImage(FIndex : Integer);
  public

  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses BFA.Func, BFA.Helper.Control;

{ TFMain }

procedure TFMain.addItem(FName, FURL : String);
var
  lb : TListBoxItem;
begin
  lb := TListBoxItem.Create(nil);
  lb.Selectable := False;
  lb.Height := lbData.Width / lbData.Columns;
  lb.StyleLookup := 'lbImage';
  lb.Text := FName;
  lb.Hint := FURL;
  //lb.StylesData['img'] := ExpandFileName(GetCurrentDir) + PathDelim + 'tes.jpg';

  lbData.AddObject(lb);
end;

procedure TFMain.btnLoadClick(Sender: TObject);
begin
  if FProses then begin
    ShowMessage('Sedang Download Image');
    Exit;
  end;

  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TFMain.fnDownloadImage(FIndex: Integer);
var
  FMXObject: TFMXObject;
  FImage: TImage;
begin
  try
    fnDownloadFile(
      lbData.ItemByIndex(FIndex).Hint,
      lbData.ItemByIndex(FIndex).Text
    );

    var ABitmap : TBitmap;
    ABitmap := TBitmap.Create;
    try
      try
        LoadImageCenter(ABitmap, fnLoadFile(lbData.ItemByIndex(FIndex).Text));
      except
        DeleteFile(fnLoadFile(lbData.ItemByIndex(FIndex).Text));
        LoadImageCenter(ABitmap, fnLoadFile('noimage.png'));
      end;
      ABitmap.SaveToFile(fnLoadFile(lbData.ItemByIndex(FIndex).Text));
    finally
      ABitmap.DisposeOf;
    end;

    TThread.Synchronize(TThread.CurrentThread, procedure begin
      if FileExists(fnLoadFile(lbData.ItemByIndex(FIndex).Text)) then
        lbData.ItemByIndex(FIndex).StylesData['img'] := fnLoadFile(lbData.ItemByIndex(FIndex).Text)
      else
        lbData.ItemByIndex(FIndex).StylesData['img'] := fnLoadFile('noimage.png');
    end);
  finally
    Inc(FLoad);
  end;
end;

procedure TFMain.fnLoadData;
var
  req : String;
  FHeight : Single;
  FCount : Integer;
begin
  FProses := True;
  try
    FCount := StrToIntDef(edCount.Text, 1);
    TThread.Synchronize(nil, procedure begin
      lblCount.Text := '0 / ' + FCount.ToString;
      pbProgress.Min := 0;
      pbProgress.Value := 0;
      pbProgress.Max := FCount;

      lbData.Items.Clear;
      tiCount.Enabled := True;
    end);

    TThread.Synchronize(nil, procedure begin
      lbData.BeginUpdate;
      try
        for var i := 0 to FCount - 1 do begin
          addItem(
            i.ToString + '.jpg',
            'https://picsum.photos/200'
          );
        end;
      finally
        lbData.EndUpdate;
      end;
    end);

    FLoad := 0;

    TParallel.For(4, 0, lbData.Items.Count - 1, procedure (i : Integer) begin
      fnDownloadImage(i);
    end);
  finally
    FProses := False;
    TThread.Synchronize(nil, procedure begin
      tiCount.Enabled := False;
      pbProgress.Value := FCount;
      lblCount.Text := FCount.ToString + ' / ' + FCount.ToString;
    end);
  end;
end;

procedure TFMain.tiCountTimer(Sender: TObject);
begin
  if FProses then begin
    pbProgress.Value := FLoad;
    lblCount.Text := FLoad.ToString + ' / ' + pbProgress.Max.ToString;
  end else begin
    pbProgress.Value := pbProgress.Max;
    lblCount.Text := pbProgress.Max.ToString + ' / ' + pbProgress.Max.ToString;
  end;
end;

end.


