unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.IOUtils,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs;

type
  TDM = class(TDataModule)
    Conn: TFDConnection;
    QTemp1: TFDQuery;
    procedure ConnBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.ConnBeforeConnect(Sender: TObject);
begin
  {$IF DEFINED (ANDROID)}
    Conn.Params.Values['Database'] := TPath.GetDocumentsPath + PathDelim + 'dbSample.db';
  {$ELSEIF DEFINED (MSWINDOWS)}

  {$ENDIF}
end;

end.
