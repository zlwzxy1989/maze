object Form2: TForm2
  Left = 0
  Top = 0
  Caption = #12458#12503#12471#12519#12531
  ClientHeight = 132
  ClientWidth = 223
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 34
    Height = 13
    Caption = #12510#12473#24133':'
  end
  object Edit1: TEdit
    Left = 94
    Top = 13
    Width = 91
    Height = 21
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 64
    Top = 83
    Width = 75
    Height = 25
    Caption = #20445#23384
    TabOrder = 1
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 48
    Width = 97
    Height = 17
    Caption = #12450#12491#12513#21177#26524
    TabOrder = 2
  end
end
