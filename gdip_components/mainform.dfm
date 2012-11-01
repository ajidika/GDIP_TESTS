object Form1: TForm1
  Left = 191
  Top = 114
  Width = 878
  Height = 375
  Caption = 'Form1'
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 862
    Height = 339
    Align = alClient
    AutoSize = True
    Stretch = True
  end
  object Bevel1: TBevel
    Left = 552
    Top = 8
    Width = 9
    Height = 325
    Shape = bsLeftLine
  end
  object Panel1: TPanel
    Left = 320
    Top = 8
    Width = 222
    Height = 325
    Caption = 'Panel1'
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      222
      325)
    object lvClock: TListView
      Left = 1
      Top = 1
      Width = 220
      Height = 285
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'Time'
          Width = 80
        end
        item
          Caption = 'Value'
        end>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = lvClockSelectItem
    end
    object dtMain: TDateTimePicker
      Left = 8
      Top = 294
      Width = 73
      Height = 21
      Anchors = [akLeft, akBottom]
      Date = 41210.000000000000000000
      Time = 41210.000000000000000000
      Kind = dtkTime
      TabOrder = 1
    end
    object edtValue: TEdit
      Left = 87
      Top = 294
      Width = 41
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 2
      Text = '0'
    end
    object udValue: TUpDown
      Left = 128
      Top = 294
      Width = 16
      Height = 21
      Anchors = [akLeft, akBottom]
      Associate = edtValue
      TabOrder = 3
    end
    object Button1: TButton
      Left = 150
      Top = 292
      Width = 25
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = '+'
      TabOrder = 4
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 181
      Top = 292
      Width = 27
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'X'
      TabOrder = 5
      OnClick = Button2Click
    end
  end
  object trbLuminosity: TTrackBar
    Left = 800
    Top = 8
    Width = 45
    Height = 325
    Max = 100
    Orientation = trVertical
    TabOrder = 1
    OnChange = trbLuminosityChange
  end
end
