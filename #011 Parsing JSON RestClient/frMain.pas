unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Controls.Presentation,
  FMX.StdCtrls, REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.Edit;

type
  TForm1 = class(TForm)
    btnLoad: TCornerButton;
    stgData: TStringGrid;
    stgSubData: TStringGrid;
    RClient: TRESTClient;
    RReq: TRESTRequest;
    RResp: TRESTResponse;
    RRespAdapter: TRESTResponseDataSetAdapter;
    memData: TFDMemTable;
    edKeyword: TEdit;
    procedure btnLoadClick(Sender: TObject);
    procedure stgDataCellClick(const Column: TColumn; const Row: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  RReq.Params.Clear;
  RReq.AddParameter('keyword', edKeyword.Text);
  try
    RClient.BaseURL := 'https://www.blangkon.net/JSON/API.php?act=findDataGet';
    RResp.RootElement := '';
    RReq.Method := TRESTRequestMethod.rmGET;

    RRespAdapter.Response := RResp;
    RRespAdapter.Dataset := memData;
    RReq.Execute;

    if memData.IsEmpty then begin
      ShowMessage('Data Kosong');
      Exit;
    end;


    stgData.ClearColumns;
    for var i := 0 to memData.FieldCount - 1 do begin
      var sc := TStringColumn.Create(nil);
      sc.Header := memData.FieldDefs[i].Name;
      stgData.AddObject(sc);
    end;

    stgData.RowCount := memData.RecordCount;

    for var i := 0 to memData.RecordCount - 1 do begin
      for var ii := 0 to memData.FieldCount - 1 do
        stgData.Cells[ii, i] := memData.FieldByName(memData.FieldDefs[ii].Name).AsString;

      memData.Next;
    end;
  except
    ShowMessage('Error');
  end;
end;

procedure TForm1.stgDataCellClick(const Column: TColumn; const Row: Integer);
begin
  RResp.RootElement := Format('[%d].data', [Row]);
  memData.First;

  if memData.IsEmpty then begin
    ShowMessage('Data Kosong');
    Exit;
  end;

  stgSubData.ClearColumns;
  for var i := 0 to memData.FieldCount - 1 do begin
    var sc := TStringColumn.Create(nil);
    sc.Header := memData.FieldDefs[i].Name;
    stgSubData.AddObject(sc);
  end;

  stgSubData.RowCount := memData.RecordCount;

  for var i := 0 to memData.RecordCount - 1 do begin
    for var ii := 0 to memData.FieldCount - 1 do
      stgSubData.Cells[ii, i] := memData.FieldByName(memData.FieldDefs[ii].Name).AsString;

    memData.Next;
  end;
end;

end.
