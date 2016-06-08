object MainFRM: TMainFRM
  Left = 193
  Top = 115
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Server :: '#1040#1076#1084#1080#1085#1080#1089#1090#1088#1080#1088#1086#1074#1072#1085#1080#1077' ::'
  ClientHeight = 446
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gbServer: TGroupBox
    Left = 464
    Top = 392
    Width = 161
    Height = 49
    Caption = #1057#1077#1088#1074#1077#1088
    TabOrder = 1
    object btnLoad: TButton
      Left = 8
      Top = 16
      Width = 73
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 0
      OnClick = btnLoadClick
    end
    object btnUnload: TButton
      Left = 80
      Top = 16
      Width = 73
      Height = 25
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
      Enabled = False
      TabOrder = 1
      OnClick = btnUnloadClick
    end
  end
  object ctrPage: TPageControl
    Left = 232
    Top = 8
    Width = 393
    Height = 385
    ActivePage = ctPage2
    MultiLine = True
    TabOrder = 0
    object ctPage1: TTabSheet
      Caption = #1057#1077#1090#1077#1074#1086#1081' '#1089#1090#1072#1090#1091#1089
      object lblState: TLabel
        Left = 5
        Top = 0
        Width = 99
        Height = 13
        Caption = #1057#1090#1072#1090#1091#1089' '#1090#1088#1072#1085#1089#1083#1103#1094#1080#1080':'
      end
      object txtLog: TMemo
        Left = 5
        Top = 16
        Width = 375
        Height = 305
        Lines.Strings = (
          'txtLog')
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
      object btnClear: TButton
        Left = 301
        Top = 328
        Width = 81
        Height = 25
        Caption = #1054#1095#1080#1089#1090#1082#1072
        TabOrder = 1
        OnClick = btnClearClick
      end
      object btnOpen: TButton
        Left = 5
        Top = 328
        Width = 89
        Height = 25
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1087#1082#1091
        TabOrder = 2
        OnClick = btnOpenClick
      end
    end
    object ctPage2: TTabSheet
      Caption = 'SQL '#1052#1072#1089#1090#1077#1088
      ImageIndex = 1
      object Label3: TLabel
        Left = 5
        Top = 0
        Width = 46
        Height = 13
        Caption = #1050#1086#1076' SQL:'
      end
      object txtSQL: TMemo
        Left = 5
        Top = 16
        Width = 375
        Height = 305
        Lines.Strings = (
          'select *')
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
      object btnRunSQL: TButton
        Left = 307
        Top = 328
        Width = 73
        Height = 25
        Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
        TabOrder = 1
        OnClick = btnRunSQLClick
      end
    end
  end
  object gbConnects: TGroupBox
    Left = 8
    Top = 8
    Width = 217
    Height = 433
    Caption = #1040#1082#1090#1080#1074#1085#1099#1077' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103':'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    object btnKick: TSpeedButton
      Left = 8
      Top = 403
      Width = 33
      Height = 25
      Hint = #1056#1072#1079#1086#1088#1074#1072#1090#1100' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1102' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECC4D5EED8E9ECD8E9ECD8
        E9ECD8E9ECD8E9ECD8E9ECD8E9EC6578F50010FF2234FCD8E9ECD8E9ECD8E9EC
        D8E9EC1223FD0010FF3B4EF9D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0416
        FE0010FF0111FFD8E9ECD8E9ECD8E9ECD8E9EC0F21FD0011FF0313FFD8E9ECD8
        E9ECD8E9ECD8E9ECD8E9ECD1E3ED0111FF0010FF5060F8D8E9ECD8E9ECD8E9EC
        D8E9ECD1E3ED0112FF0010FF96A7F2D8E9ECD8E9ECD8E9ECD8E9EC586BF80010
        FF0313FFD1E3EDD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC3848FA0010FF1F2FFDD8
        E9ECD8E9ECD8E9ECD1E3ED0313FF0010FF5061F8D8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECBDD0EF0314FF0011FF6475F6D8E9ECD8E9EC1C2CFD0010FF0213
        FFCADDEED8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC5E6FF70010FF03
        13FFD1E3ED2A3AFB0010FF0011FF8C9CF3D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECD8E9ECD8E9EC0E1EFE0010FF0414FF0011FF0111FF6575F6D8E9
        ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECABBCF00C1DFD00
        10FF0011FF0111FF798BF5D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECBDD0EF0313FF0010FF0011FF0010FF0314FFA7B9F1D8E9ECD8E9
        ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD1E3ED1E31FB0111FF0011FF0A1BFEBD
        CEEE1122FE0011FF0C1CFEC4D6EED8E9ECD8E9ECD8E9ECD8E9ECD8E9ECCADDEE
        0011FF0010FF0010FF1324FDC4D6EED8E9ECC4D6EE0617FE0011FF0111FE0D1D
        FED8E9ECD8E9ECD8E9ECD8E9ECD1E3ED0011FF0011FF6073F6D8E9ECD8E9ECD8
        E9ECD8E9ECA0B1F10010FF0010FF0010FF7C8DF4D8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC6579F50112FE0D1E
        FED8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
        E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnKickClick
    end
    object usrList: TOutline
      Left = 8
      Top = 16
      Width = 201
      Height = 385
      Options = [ooDrawTreeRoot]
      ItemHeight = 13
      Color = clBtnFace
      TabOrder = 0
      ItemSeparator = '\'
      PicturePlus.Data = {
        46030000424D460300000000000036000000280000000E0000000E0000000100
        200000000000100300000000000000000000000000000000000000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000000000000000000000
        000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000000000FFFFFF000000000000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000000000FFFFFF000000000000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF000000000000000000000000000000
        0000FFFFFF000000000000000000000000000000000000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF000000000000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000000000000000000000000000000000FFFFFF0000000000000000000000
        00000000000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000000000FFFFFF000000000000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF000000
        0000FFFFFF000000000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000000000000000000000
        000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF00}
      PictureMinus.Data = {
        46030000424D460300000000000036000000280000000E0000000E0000000100
        200000000000100300000000000000000000000000000000000000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF000000000000000000000000000000
        000000000000000000000000000000000000000000000000000000BFBF0000BF
        BF0000BFBF0000BFBF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF000000000000BFBF0000BFBF0000BFBF0000BF
        BF00000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF00}
      PictureOpen.Data = {
        46030000424D460300000000000036000000280000000E0000000E0000000100
        2000000000001003000000000000000000000000000000000000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080000000000000000000000000000000000000000000000000000000
        0000000000008000800080008000800080008000800080008000000000000000
        000000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF000000
        0000800080008000800080008000800080000000000000FFFF000000000000FF
        FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00000000008000
        800080008000800080000000000000FFFF0000FFFF000000000000FFFF00C0C0
        C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF0000000000800080008000
        800000000000FFFFFF0000FFFF0000FFFF000000000000000000000000000000
        00000000000000000000000000000000000080008000800080000000000000FF
        FF00FFFFFF0000FFFF000000000000FFFF000000000000FFFF000000000000FF
        FF000000000080008000800080008000800000000000FFFFFF0000FFFF00FFFF
        FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF0000000000000000008000
        800080008000800080000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
        FF00FFFFFF000000000000000000000000008000800080008000800080008000
        8000800080000000000000FFFF00FFFFFF0000FFFF00FFFFFF00000000008000
        8000800080008000800080008000800080008000800080008000800080008080
        8000000000000000000000000000000000008080800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        80008000800080008000}
      PictureClosed.Data = {
        46030000424D460300000000000036000000280000000E0000000E0000000100
        2000000000001003000000000000000000000000000000000000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080000000000000000000000000000000000000000000000000000000
        00000000000000000000000000008000800080008000800080000000000000FF
        FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
        FF000000000080008000800080008000800000000000FFFFFF0000FFFF00FFFF
        FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000008000
        800080008000800080000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
        FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000080008000800080008000
        800000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
        FF0000FFFF00FFFFFF00000000008000800080008000800080000000000000FF
        FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
        FF000000000080008000800080008000800000000000FFFFFF0000FFFF00FFFF
        FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000008000
        8000800080008000800000000000000000000000000000000000000000000000
        0000000000000000000000000000000000008000800080008000800080008000
        80008000800000000000FFFFFF0000FFFF00FFFFFF0000FFFF00000000008000
        8000800080008000800080008000800080008000800080008000800080008080
        8000000000000000000000000000000000008080800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        80008000800080008000}
      PictureLeaf.Data = {
        46030000424D460300000000000036000000280000000E0000000E0000000100
        2000000000001003000000000000000000000000000000000000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000000000000000000000000000000000000000000000000000000000000000
        000000000000800080008000800080008000800080008000800000000000FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000008000
        80008000800080008000800080008000800000000000FFFFFF00000000000000
        0000000000000000000000000000FFFFFF000000000080008000800080008000
        8000800080008000800000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF0000000000800080008000800080008000800080008000
        800000000000FFFFFF000000000000000000000000000000000000000000FFFF
        FF0000000000800080008000800080008000800080008000800000000000FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000008000
        80008000800080008000800080008000800000000000FFFFFF00000000000000
        000000000000FFFFFF00FFFFFF00FFFFFF000000000080008000800080008000
        8000800080008000800000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00000000000000000000000000800080008000800080008000800080008000
        800000000000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFF
        FF0000000000800080008000800080008000800080008000800000000000FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000800080008000
        8000800080008000800080008000800080000000000000000000000000000000
        0000000000000000000000000000800080008000800080008000800080008000
        80008000800080008000}
      ParentShowHint = False
      ShowHint = False
      ScrollBars = ssVertical
      Data = {1F}
    end
    object btnRefresh: TButton
      Left = 144
      Top = 403
      Width = 65
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 1
    end
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=sa;Initial Catalog=db1SQL;Data Source=MAC1\SQLE' +
      'XPRESS'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'SQLOLEDB.1'
    Left = 488
    Top = 80
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    LockType = ltBatchOptimistic
    Parameters = <>
    Left = 488
    Top = 144
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Enabled = False
    Left = 488
    Top = 112
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 488
    Top = 176
  end
  object tPing: TTimer
    Enabled = False
    Interval = 350
    OnTimer = tPingTimer
    Left = 488
    Top = 216
  end
  object tTimeOut: TTimer
    Enabled = False
    OnTimer = tTimeOutTimer
    Left = 520
    Top = 216
  end
  object XPManifest1: TXPManifest
    Left = 520
    Top = 176
  end
end