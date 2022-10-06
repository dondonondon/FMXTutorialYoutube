object DM: TDM
  OldCreateOrder = False
  Height = 348
  Width = 537
  object Conn: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\LENOVO\Documents\Blangkon\Aplikasi\Android Dat' +
        'a Tamu\Guest\assets\database\db_tamu.db'
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = ConnBeforeConnect
    Left = 16
    Top = 8
  end
  object QTemp1: TFDQuery
    Connection = Conn
    FetchOptions.AssignedValues = [evRowsetSize]
    FetchOptions.RowsetSize = 5000
    Left = 16
    Top = 64
  end
  object QTemp2: TFDQuery
    Connection = Conn
    FetchOptions.AssignedValues = [evRowsetSize]
    FetchOptions.RowsetSize = 5000
    Left = 72
    Top = 64
  end
  object QTemp3: TFDQuery
    Connection = Conn
    FetchOptions.AssignedValues = [evRowsetSize]
    FetchOptions.RowsetSize = 5000
    Left = 120
    Top = 64
  end
  object QTemp4: TFDQuery
    Connection = Conn
    FetchOptions.AssignedValues = [evRowsetSize]
    FetchOptions.RowsetSize = 5000
    Left = 176
    Top = 64
  end
  object img: TImageList
    Source = <
      item
        MultiResBitmap.Height = 96
        MultiResBitmap.Width = 96
        MultiResBitmap.LoadSize = 0
        MultiResBitmap = <
          item
            Width = 96
            Height = 96
            PNG = {
              89504E470D0A1A0A0000000D4948445200000060000000600806000000E29877
              38000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
              009249444154785EEDDAB10D0321140541ECAEE83FA02C3B213D07964E7B4233
              C92766D337000000000000E068AF7D2FCD393FFBC91FD65A3FFFF8BD2F110162
              02C404880910132026404C8098000000000000703EC3AC9B19663D9C00310162
              02C404880910132026404C000000000000389F61D6CD0CB31E4E809800310162
              02C40488091013202600000000000000709B31BE0D8C0C3A9E02997100000000
              49454E44AE426082}
            FileName = 
              'D:\Job\Tutorial\Youtube Live\001 - Design\assets\icons\bx_menu.p' +
              'ng'
          end>
        Name = 'bx_menu'
      end
      item
        MultiResBitmap.Height = 96
        MultiResBitmap.Width = 96
        MultiResBitmap.LoadSize = 0
        MultiResBitmap = <
          item
            Width = 96
            Height = 96
            PNG = {
              89504E470D0A1A0A0000000D4948445200000060000000600806000000E29877
              38000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
              01F849444154785EEDDAB171C23014C671EC86362330423A4A924DB201192519
              2193043AE8320223A4850222811A2E18BD87F21E52EEFFBBE32C5C50F8B38D25
              7F230000000000000000F0EF75699B359BCD1E76BBDD6B1C86CFD37127CEECF7
              FBAFAEEBDE56ABD547DA95250A603A9D4EFABEFF0CC3C9690F3236218CE7F57A
              BD49DF07F5697B15075FED78C2C6BB46FA3E281B4038FB5FC28683AF37D96EB7
              F3341E24B902B23F82CBC2FF41F6BF321B40B8941ED3107AE501C096248045DA
              42293E96A6E1A06C0087C381006E14E7046938281BC0783C7E0F9BECF32C7ED9
              482664D90096CBE5779C54842121C81D2762697C957829224A7382394F4697A5
              DBF522DE35E2897BDA0B0000000000009CA816E34AB4D02BBAA5D753CA258006
              7B45E25E4F299777C20DF68AC4BD9E52E60134DC2B12F57A4A795C01CDF68A24
              BD9E52E60134FEF6ACFD00709D4700CDD65A24BD9E52E601B4DC2B92F47A4A99
              07D070AF48D4EB29651E40A3BD2271AFA794DB5244547BAF885E0F0000000000
              002CB92EC669FC458FE81E3D1FAD2A0330E811B9F57CB4AA7C276CD02372EBF9
              68551780618FC8A5E7A355E3156076903C7A3E5AD50560FCB68C0070AEC600CC
              6A2C1E3D1FADEA02B0EC1179F47CB4AA0BC0B047E4D2F3D1AA2E00A31E915BCF
              47ABDAA588A8B44744CF0700000000000000000000703FA3D10F3092C3404C2B
              9FA60000000049454E44AE426082}
            FileName = 
              'D:\Job\Tutorial\Youtube Live\001 - Design\assets\icons\fluent_fi' +
              'lter-12-filled.png'
          end>
        Name = 'fluent_filter-12-filled'
      end>
    Destination = <
      item
        Layers = <
          item
            Name = 'bx_menu'
            SourceRect.Right = 96.000000000000000000
            SourceRect.Bottom = 96.000000000000000000
          end>
      end
      item
        Layers = <
          item
            Name = 'fluent_filter-12-filled'
            SourceRect.Right = 96.000000000000000000
            SourceRect.Bottom = 96.000000000000000000
          end>
      end>
    Left = 496
    Top = 8
  end
  object RClient: TRESTClient
    Accept = 'application/json;q=0.9,text/plain;q=0.9,text/html'
    AcceptCharset = 'UTF-8'
    BaseURL = 
      'https://www.blangkon.net/_loader_json/WebService/Emas/API/getDat' +
      'a.php?key=hUIY!*DH!Ey928HD892H89@Y79@&act=getADS'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 72
    Top = 200
  end
  object RReq: TRESTRequest
    AssignedValues = [rvAccept, rvAcceptCharset, rvConnectTimeout, rvReadTimeout]
    Accept = 'application/json;q=0.9,text/plain;q=0.9,text/html'
    AcceptCharset = 'UTF-8'
    Client = RClient
    Params = <>
    Response = RResp
    ConnectTimeout = 17000
    ReadTimeout = 17000
    SynchronizedEvents = False
    Left = 144
    Top = 200
  end
  object RResp: TRESTResponse
    Left = 216
    Top = 200
  end
  object bgRClient: TRESTClient
    Accept = 'application/json;q=0.9,text/plain;q=0.9,text/html'
    AcceptCharset = 'UTF-8'
    BaseURL = 
      'https://www.blangkon.net/_loader_json/WebService/Emas/API/getDat' +
      'a.php?key=hUIY!*DH!Ey928HD892H89@Y79@&act=getADS'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 72
    Top = 256
  end
  object bgRReq: TRESTRequest
    AssignedValues = [rvAccept, rvAcceptCharset, rvConnectTimeout, rvReadTimeout]
    Accept = 'application/json;q=0.9,text/plain;q=0.9,text/html'
    AcceptCharset = 'UTF-8'
    Client = bgRClient
    Params = <>
    Response = bgRResp
    ConnectTimeout = 20000
    ReadTimeout = 20000
    SynchronizedEvents = False
    Left = 144
    Top = 256
  end
  object bgRResp: TRESTResponse
    ContentType = 'text/html'
    Left = 216
    Top = 256
  end
  object nHTTP: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 16
    Top = 128
  end
  object rRespAdapter: TRESTResponseDataSetAdapter
    Dataset = memData
    FieldDefs = <>
    Response = RResp
    Left = 16
    Top = 200
  end
  object memData: TFDMemTable
    FilterOptions = [foCaseInsensitive]
    FieldDefs = <
      item
        Name = 'asd'
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 16
    Top = 256
  end
end
