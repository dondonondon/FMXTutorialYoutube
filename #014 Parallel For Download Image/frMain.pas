unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, System.Threading;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    CornerButton1: TCornerButton;
    Edit1: TEdit;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    lbMain: TListBox;
    a: TListBoxItem;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    SB: TStyleBook;
    tiCount: TTimer;
    procedure CornerButton1Click(Sender: TObject);
    procedure tiCountTimer(Sender: TObject);
  private
    FProses : Boolean;
    FLoad : Integer;
    procedure addItem(FName, FURL : String);  //ctrl + shift + c
    procedure fnLoadData;   //ctrl + shift + c
    procedure fnDownloadImage(FIndex : Integer); //ctrl + shift + c
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses BFA.Func;

{ TForm1 }

procedure TForm1.addItem(FName, FURL: String);
var
  lb : TListBoxItem;
begin
  lb := TListBoxItem.Create(nil);
  lb.Selectable := False;
  lb.Height := lbMain.Width / lbMain.Columns;
  lb.StyleLookup := 'lbImage';
  lb.Text := FName;
  lb.Hint := FURL;

  lbMain.AddObject(lb);
end;

procedure TForm1.CornerButton1Click(Sender: TObject);
begin
  if FProses then begin
    ShowMessage('Download Sedang Berlangsung');
    Exit;
  end;

  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TForm1.fnDownloadImage(FIndex: Integer);
begin
  try
    fnDownloadFile(
      lbMain.ItemByIndex(FIndex).Hint,
      lbMain.ItemByIndex(FIndex).Text
    );

    TThread.Synchronize(nil, procedure begin
      if FileExists(fnLoadFile(lbMain.ItemByIndex(FIndex).Text)) then
        lbMain.ItemByIndex(FIndex).StylesData['img'] := fnLoadFile(lbMain.ItemByIndex(FIndex).Text)
      else
        lbMain.ItemByIndex(FIndex).StylesData['img'] := fnLoadFile('noimage.png');
    end);
  finally
    Inc(FLoad);
  end;
end;

procedure TForm1.fnLoadData;
var
  FCount : Integer;
begin
  FProses := True;
  try
    FCount := StrToUIntDef(Edit1.Text, 1);
    TThread.Synchronize(nil, procedure begin
      Label1.Text := '0 / ' + FCount.ToString;
      ProgressBar1.Min := 0;
      ProgressBar1.Value := 0;
      ProgressBar1.Max := FCount;

      lbMain.Items.Clear;
      tiCount.Enabled := True;

      lbMain.BeginUpdate;
      try
        for var i := 0 to FCount - 1 do begin
          addItem(
            i.ToString + '.jpg',
            'https://picsum.photos/200'
          );
        end;
      finally
        lbMain.EndUpdate;
      end;

      FLoad := 0;

    end);

    TParallel.For(4, 0, lbMain.Items.Count - 1, procedure (i : Integer) begin
      fnDownloadImage(i);
    end);
  finally
    FProses := False;
    TThread.Synchronize(nil, procedure begin
      tiCount.Enabled := False;
      ProgressBar1.Value := FCount;
      Label1.Text := FCount.ToString + ' / ' + FCount.ToString;
    end);
  end;
end;

procedure TForm1.tiCountTimer(Sender: TObject);
begin
  if FProses then begin
    ProgressBar1.Value := FLoad;
    Label1.Text := FLoad.ToString + ' / ' + ProgressBar1.Max.ToString;
  end else begin
    ProgressBar1.Value := ProgressBar1.Max;
    Label1.Text := ProgressBar1.Max.ToString + ' / ' + ProgressBar1.Max.ToString;
  end;
end;

end.
