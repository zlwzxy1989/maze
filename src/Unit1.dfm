object uMain: TuMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #36855#23470#35299#12365#12487#12514
  ClientHeight = 98
  ClientWidth = 192
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 22
    Top = 11
    Width = 28
    Height = 13
    Caption = #36215#28857':'
    Visible = False
  end
  object Label3: TLabel
    Left = 22
    Top = 47
    Width = 246
    Height = 13
    Caption = #22352#26631#26684#24335#20026'x,y'#65292#20174'0'#24320#22987#35745#25968#12290#20363#22914#24038#19978#35282#20026'0,0'
    Visible = False
  end
  object Label2: TLabel
    Left = 136
    Top = 11
    Width = 28
    Height = 13
    Caption = #32456#28857':'
    Visible = False
  end
  object PaintBoxMain: TPaintBox
    Left = 0
    Top = 0
    Width = 192
    Height = 98
    Align = alClient
    OnPaint = PaintBoxMainPaint
    ExplicitWidth = 483
    ExplicitHeight = 5
  end
  object Edit1: TEdit
    Left = 56
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 0
    Visible = False
  end
  object Button1: TButton
    Left = 271
    Top = 8
    Width = 75
    Height = 25
    Caption = #23548#20837
    TabOrder = 1
    Visible = False
  end
  object Edit2: TEdit
    Left = 181
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 2
    Visible = False
  end
  object Button2: TButton
    Left = 368
    Top = 8
    Width = 75
    Height = 25
    Caption = #35745#31639
    TabOrder = 3
    Visible = False
  end
  object OpenDialog1: TOpenDialog
    Filter = #12486#12461#12473#12488#12501#12449#12452#12523'|*.txt'
    Left = 368
    Top = 48
  end
  object MainMenu1: TMainMenu
    Left = 328
    Top = 208
    object tab1: TMenuItem
      Caption = #12501#12449#12452#12523
      object open: TMenuItem
        Action = ActOpen
        Caption = #36855#23470#12501#12449#12452#12523#12434#38283#12367'...'
      end
      object calculate: TMenuItem
        Action = ActCalculate
        Caption = #20986#21475#12434#25506#12377
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object options: TMenuItem
        Action = ActOptions
        Caption = #12458#12503#12471#12519#12531'...'
      end
    end
  end
  object ActionList1: TActionList
    Left = 376
    Top = 208
    object ActOpen: TAction
      Caption = 'ActOpen'
      OnExecute = ActOpenExecute
    end
    object ActCalculate: TAction
      Caption = 'ActCalculate'
      OnExecute = ActCalculateExecute
    end
    object ActOptions: TAction
      Caption = 'ActOptions'
      OnExecute = ActOptionsExecute
    end
  end
end
