object DM: TDM
  OldCreateOrder = False
  Height = 400
  Width = 535
  object Conn: TFDConnection
    Params.Strings = (
      
        'Database=D:\Job\Tutorial\Youtube #1\#7 Database SQLite\assets\da' +
        'tabase\dbSample.db'
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = ConnBeforeConnect
    Left = 40
    Top = 32
  end
  object QTemp1: TFDQuery
    Connection = Conn
    SQL.Strings = (
      'SELECT * FROM tbl_biodata')
    Left = 40
    Top = 88
  end
end
