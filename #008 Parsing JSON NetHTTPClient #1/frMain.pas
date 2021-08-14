unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.Memo,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, System.JSON;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    btnLoadJSON: TCornerButton;
    memJSON: TMemo;
    stgJSON: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringColumn6: TStringColumn;
    btnLoadNestedJson: TCornerButton;
    memNestedJSON: TMemo;
    StringColumn7: TStringColumn;
    StringColumn8: TStringColumn;
    StringColumn9: TStringColumn;
    StringColumn10: TStringColumn;
    StringColumn11: TStringColumn;
    StringColumn12: TStringColumn;
    stgNestedJSON: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    lblAlias: TLabel;
    lblNama: TLabel;
    procedure btnLoadJSONClick(Sender: TObject);
    procedure btnLoadNestedJsonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btnLoadJSONClick(Sender: TObject);
var
  FNetHTTP : TNetHTTPClient;
  FNetRespon : IHTTPResponse;

  JObjectData : TJSONObject;
  JArrayJSON : TJSONArray;

  i : Integer;
  ii: Integer;
begin
  memJSON.Lines.Clear;

  for i := 0 to stgJSON.RowCount - 1 do
    for ii := 0 to stgJSON.ColumnCount - 1 do
      stgJSON.Cells[ii, i] := '';

  stgJSON.RowCount := 1;

  FNetHTTP := TNetHTTPClient.Create(nil);
  try
    try
      FNetRespon := FNetHTTP.Get('https://www.blangkon.net/JSON/json.json');
      memJSON.Lines.Add(FNetRespon.ContentAsString());
      try
        JArrayJSON := TJSONObject.ParseJSONValue(FNetRespon.ContentAsString()) as TJSONArray;
        stgJSON.RowCount := JArrayJSON.Size;

        for i := 0 to JArrayJSON.Size - 1 do begin
          JObjectData := TJSONObject(JArrayJSON.Get(i));

          stgJSON.Cells[0, i] := JObjectData.GetValue<String>('Date');
          stgJSON.Cells[1, i] := JObjectData.GetValue<Double>('Open').ToString;
          stgJSON.Cells[2, i] := JObjectData.GetValue<Double>('High').ToString;
          stgJSON.Cells[3, i] := JObjectData.GetValue<Double>('Low').ToString;
          stgJSON.Cells[4, i] := JObjectData.GetValue<Double>('Close').ToString;
          stgJSON.Cells[5, i] := JObjectData.GetValue<Integer>('Volume').ToString;
        end;
      finally
        JArrayJSON.DisposeOf;
      end;
    except
      on E : Exception do begin
        memJSON.Lines.Add(E.Message);
        memJSON.Lines.Add(E.ClassName);
      end;
    end;
  finally
    FNetHTTP.DisposeOf;
  end;
end;

procedure TForm1.btnLoadNestedJsonClick(Sender: TObject);
var
  FNetHTTP : TNetHTTPClient;
  FNetRespon : IHTTPResponse;

  JObjectData : TJSONObject;
  JArrayJSON, JArraySubJSON : TJSONArray;

  i : Integer;
  ii: Integer;
begin
  memNestedJSON.Lines.Clear;

  for i := 0 to stgNestedJSON.RowCount - 1 do
    for ii := 0 to stgNestedJSON.ColumnCount - 1 do
      stgNestedJSON.Cells[ii, i] := '';

  stgNestedJSON.RowCount := 1;

  FNetHTTP := TNetHTTPClient.Create(nil);
  try
    try
      FNetRespon := FNetHTTP.Get('https://www.blangkon.net/JSON/nested.json');
      memNestedJSON.Lines.Add(FNetRespon.ContentAsString());
      try
        JArrayJSON := TJSONObject.ParseJSONValue(FNetRespon.ContentAsString()) as TJSONArray;

        lblNama.Text := TJSONObject(JArrayJSON.Get(0)).GetValue<String>('nm_region');
        lblAlias.Text := TJSONObject(JArrayJSON.Get(0)).GetValue<String>('alias_region');
        try
          JArraySubJSON := TJSONObject.ParseJSONValue(TJSONObject(JArrayJSON.Get(0)).GetValue('data').ToJSON) as TJSONArray;
          stgNestedJSON.RowCount := JArraySubJSON.Size;
          for i := 0 to JArraySubJSON.Size - 1 do begin
            JObjectData := TJSONObject(JArraySubJSON.Get(i));

            stgNestedJSON.Cells[0, i] := JObjectData.GetValue<String>('tgl');
            stgNestedJSON.Cells[1, i] := JObjectData.GetValue<Double>('open').ToString;
            stgNestedJSON.Cells[2, i] := JObjectData.GetValue<Double>('high').ToString;
            stgNestedJSON.Cells[3, i] := JObjectData.GetValue<Double>('low').ToString;
            stgNestedJSON.Cells[4, i] := JObjectData.GetValue<Double>('close').ToString;
            stgNestedJSON.Cells[5, i] := JObjectData.GetValue<Integer>('volume').ToString;
          end;
        finally
          JArraySubJSON.DisposeOf;
        end;
      finally
        JArrayJSON.DisposeOf;
      end;
    except
      on E : Exception do begin
        memNestedJSON.Lines.Add(E.Message);
        memNestedJSON.Lines.Add(E.ClassName);
      end;
    end;
  finally
    FNetHTTP.DisposeOf;
  end;
end;

end.
