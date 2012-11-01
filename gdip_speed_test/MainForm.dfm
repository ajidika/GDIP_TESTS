object frmTest: TfrmTest
  Left = 211
  Top = 149
  Width = 1286
  Height = 675
  Caption = 'GDI+ test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pbTest: TPaintBox
    Left = 185
    Top = 0
    Width = 1085
    Height = 639
    Align = alClient
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 639
    Align = alLeft
    TabOrder = 0
    object edtFileName: TAdvFileNameEdit
      Left = 8
      Top = 24
      Width = 169
      Height = 21
      Flat = False
      FocusColor = clBtnFace
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      Color = clWindow
      Enabled = True
      ReadOnly = False
      TabOrder = 0
      Visible = True
      Version = '1.3.2.7'
      ButtonStyle = bsButton
      ButtonWidth = 18
      Etched = False
      Glyph.Data = {
        CE000000424DCE0000000000000076000000280000000C0000000B0000000100
        0400000000005800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D00000000DDD
        00000077777770DD00000F077777770D00000FF07777777000000FFF00000000
        00000FFFFFFF0DDD00000FFF00000DDD0000D000DDDDD0000000DDDDDDDDDD00
        0000DDDDD0DDD0D00000DDDDDD000DDD0000}
      Filter = '*.jpg,*.png,*.bmp,*.gif'
      FilterIndex = 0
      DialogOptions = []
      DialogKind = fdOpen
    end
    object btnImageStart: TButton
      Left = 96
      Top = 56
      Width = 75
      Height = 25
      Caption = 'btnImageStart'
      TabOrder = 1
      OnClick = btnImageStartClick
    end
    object btnRectStart: TButton
      Left = 96
      Top = 96
      Width = 75
      Height = 25
      Caption = 'btnRectStart'
      TabOrder = 2
      OnClick = btnRectStartClick
    end
    object btnCchdImgStart: TButton
      Left = 8
      Top = 56
      Width = 75
      Height = 25
      Caption = 'btnImageStart'
      TabOrder = 3
      OnClick = btnCchdImgStartClick
    end
  end
end
