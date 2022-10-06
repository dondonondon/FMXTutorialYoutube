unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.Memo, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFMain = class(TForm)
    btnLoad: TCornerButton;
    edSearch: TEdit;
    memLog: TMemo;
    stgData: TStringGrid;
    stgSubData: TStringGrid;
    memData: TFDMemTable;
    nHTTP: TNetHTTPClient;
    StringColumn1: TStringColumn;
    memSubData: TFDMemTable;
    ClearEditButton1: TClearEditButton;
    procedure btnLoadClick(Sender: TObject);
    procedure stgDataCellClick(const Column: TColumn; const Row: Integer);
    procedure edSearchTyping(Sender: TObject);
  private
    procedure fnClearStringGrid(FStringGrid : TStringGrid); //ctrl + shift + c
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses BFA.Helper.MemTable;

procedure TFMain.btnLoadClick(Sender: TObject);
begin
  memLog.Lines.Clear;
  if not memData.FillDataFromURL('https://www.blangkon.net/JSON/API.php?act=loadListSaham') then begin
    memLog.Lines.Add(memData.FieldByName('message').AsString);
    memLog.Lines.Add(memData.FieldByName('error').AsString);
  end else begin
    fnClearStringGrid(stgData);
    if memData.IsEmpty then begin
      ShowMessage('Data Kosong');
    end else begin
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
    end;
  end;

end;

procedure TFMain.edSearchTyping(Sender: TObject);
begin
  fnClearStringGrid(stgData);
  fnClearStringGrid(stgSubData);

  memData.Filtered := False;
  memData.Filter := 'nm_region LIKE ' + QuotedStr('%'+ edSearch.Text +'%');
  memData.Filtered := True;

  if memData.IsEmpty then
    Exit;

  memData.First;

  stgData.RowCount := memData.RecordCount;

  for var i := 0 to memData.RecordCount - 1 do begin
    for var ii := 0 to memData.FieldCount - 1 do
      stgData.Cells[ii, i] := memData.FieldByName(memData.FieldDefs[ii].Name).AsString;

    memData.Next;
  end;
end;

procedure TFMain.fnClearStringGrid(FStringGrid: TStringGrid);
begin
  for var i := 0 to FStringGrid.RowCount - 1 do
    for var ii := 0 to FStringGrid.ColumnCount - 1 do
      FStringGrid.Cells[ii, i] := '';

  FStringGrid.RowCount := 0;
end;

procedure TFMain.stgDataCellClick(const Column: TColumn; const Row: Integer);
begin
  memLog.Lines.Clear;
  if not memSubData.FillDataFromString(stgData.Cells[Column.Index, Row]) then begin
    memLog.Lines.Add(memSubData.FieldByName('message').AsString);
    memLog.Lines.Add(memSubData.FieldByName('error').AsString);
  end else begin
    fnClearStringGrid(stgSubData);
    if memSubData.IsEmpty then begin
      ShowMessage('Data Kosong');
    end else begin
      stgSubData.ClearColumns;
      for var i := 0 to memSubData.FieldCount - 1 do begin
        var sc := TStringColumn.Create(nil);
        sc.Header := memSubData.FieldDefs[i].Name;
        stgSubData.AddObject(sc);
      end;

      stgSubData.RowCount := memSubData.RecordCount;

      for var i := 0 to memSubData.RecordCount - 1 do begin
        for var ii := 0 to memSubData.FieldCount - 1 do
          stgSubData.Cells[ii, i] := memSubData.FieldByName(memSubData.FieldDefs[ii].Name).AsString;

        memSubData.Next;
      end;
    end;
  end;
end;

end.
