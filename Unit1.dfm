object Form1: TForm1
  Left = 0
  Top = 0
  ClientHeight = 665
  ClientWidth = 906
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 646
    Width = 906
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 906
    Height = 646
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #23186#20307
      object Label1: TLabel
        Left = 664
        Top = 735
        Width = 31
        Height = 13
        Caption = 'Label1'
      end
      object ListView1: TListView
        Left = 0
        Top = 0
        Width = 898
        Height = 618
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = #20013#25991#21517'/'#31616#20171
          end
          item
            AutoSize = True
            Caption = #21407#21517
          end
          item
            Caption = #26102#38388
          end
          item
            Caption = #21095#38598
          end
          item
            Caption = #25991#20214#21517
          end
          item
            Caption = #20449#24687
          end
          item
            Caption = #24314#31435#26102#38388
          end
          item
            Caption = 'Hash'
          end>
        GridLines = True
        MultiSelect = True
        RowSelect = True
        PopupMenu = PopupMenu2
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = ListView1Click
        OnColumnClick = ListView1ColumnClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = #31649#29702
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 3
        Top = 16
        Width = 486
        Height = 153
        Caption = #30446#24405#25195#25551
        TabOrder = 0
        object pathListBox: TListBox
          Left = 16
          Top = 24
          Width = 456
          Height = 89
          Style = lbOwnerDrawFixed
          ItemHeight = 13
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnDrawItem = pathListBoxDrawItem
        end
        object addPathButton: TButton
          Left = 374
          Top = 119
          Width = 98
          Height = 25
          Caption = #28155#21152#30446#24405'...'
          TabOrder = 1
          OnClick = addPathButtonClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 175
        Width = 486
        Height = 210
        Caption = 'RSS'#35746#38405
        TabOrder = 1
        object Label2: TLabel
          Left = 154
          Top = 19
          Width = 49
          Height = 13
          Caption = #35746#38405'Url'#65306
        end
        object Label3: TLabel
          Left = 154
          Top = 59
          Width = 48
          Height = 13
          Caption = #33258#23450#21035#21517
        end
        object Label4: TLabel
          Left = 160
          Top = 96
          Width = 312
          Height = 78
          Caption = 
            '1'#12289#36825#20010#21151#33021#26159#20511#29992'utorrent'#31561'BT'#36719#20214#20351#29992#30340'PT'#31449'RSS'#35746#38405#13#19979#36733#38142#25509#65292#26469#33719#21462'PT'#19979#36733#30340#23186#20307#21103#26631#39064#65292#20197#20415#26234#33021#36873#21462#13#23383#24149#21644#28155 +
            #21152#23186#20307#20449#24687#12290#13'2'#12289#24456#22810'PT'#31449#29992#8220#23567#36135#36710#8221#12289#8220#30334#23453#31665#8221#31561#20195#26367#21407#25910#34255'RSS'#35746#38405#65292#13#29983#25104'RSS'#19979#36733#38142#25509#26102#20250#32570#23569#21103#26631#39064#21644#25991#20214#22823#23567#31561#25105#20204#24517 +
            #29992#13#30340#36873#39033#65292#22909#21543#65292#36825#20004#20010#36873#39033#25105#20204#33258#21160#28155#21152#36827#21435#65292#19981#29992#25285#24515#12290
        end
        object rssListBox: TListBox
          Left = 16
          Top = 16
          Width = 132
          Height = 177
          ItemHeight = 13
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnClick = rssListBoxClick
          OnMouseDown = rssListBoxMouseDown
        end
        object rssNameEdit: TEdit
          Left = 216
          Top = 56
          Width = 65
          Height = 21
          TabOrder = 1
        end
        object addRssButton: TButton
          Left = 287
          Top = 56
          Width = 74
          Height = 25
          Caption = #28155#21152'RSS'
          TabOrder = 2
          OnClick = addRssButtonClick
        end
        object rssUrlEdit: TEdit
          Left = 216
          Top = 19
          Width = 249
          Height = 21
          TabOrder = 3
        end
        object updateRssButton: TButton
          Left = 390
          Top = 57
          Width = 75
          Height = 25
          Caption = #25163#21160#26356#26032
          TabOrder = 4
          OnClick = updateRssButtonClick
        end
      end
      object GroupBox3: TGroupBox
        Left = 495
        Top = 16
        Width = 394
        Height = 209
        Caption = #20559#22909
        TabOrder = 2
        object Label5: TLabel
          Left = 16
          Top = 79
          Width = 216
          Height = 13
          Caption = #23383#24149#32452#20248#20808#39034#24207#65288#35831#25226#21916#27426#30340#25490#21069#19968#28857#65289
        end
        object Label6: TLabel
          Left = 18
          Top = 24
          Width = 277
          Height = 13
          Caption = #23383#24149#35821#35328#20248#20808#39034#24207#65288'chs'#31616#20307';cht'#32321#20307';eng'#33521#25991';'#21452#35821#65289
        end
        object lbl1: TLabel
          Left = 18
          Top = 156
          Width = 192
          Height = 13
          Caption = #21407#26631#39064#36807#28388#35789#65288#38500#24433#21517#22806#30340#20854#23427#35789#65289
        end
        object subLanSortEdit: TEdit
          Left = 16
          Top = 43
          Width = 361
          Height = 21
          TabOrder = 0
          OnChange = subLanSortEditChange
        end
        object subTeamEdit: TEdit
          Left = 16
          Top = 98
          Width = 361
          Height = 21
          TabOrder = 1
          OnChange = subTeamEditChange
        end
        object subonlyCheckBox: TCheckBox
          Left = 16
          Top = 120
          Width = 361
          Height = 22
          Caption = '  '#25105#26159#22788#22899#24231#24615#26684#65292#20165#29992#19978#36848#35821#35328#25110#23383#24149#32452
          TabOrder = 2
          OnClick = subonlyCheckBoxClick
        end
        object edtdeltxttitle: TEdit
          Left = 16
          Top = 175
          Width = 361
          Height = 21
          TabOrder = 3
          Text = 'edtdeltxttitle'
          OnChange = edtdeltxttitleChange
        end
      end
      object GroupBox4: TGroupBox
        Left = 495
        Top = 295
        Width = 394
        Height = 90
        Caption = #23450#26102#20219#21153
        TabOrder = 3
        object Label7: TLabel
          Left = 19
          Top = 21
          Width = 104
          Height = 13
          Caption = #30446#24405#25195#25551#38388#38548'('#23567#26102')'
        end
        object Label8: TLabel
          Left = 203
          Top = 53
          Width = 104
          Height = 13
          Caption = #23383#24149#25628#23547#38388#38548'('#23567#26102')'
        end
        object Label9: TLabel
          Left = 19
          Top = 53
          Width = 104
          Height = 13
          Caption = #20449#24687#21038#21066#38388#38548'('#23567#26102')'
        end
        object Label10: TLabel
          Left = 203
          Top = 21
          Width = 163
          Height = 13
          Caption = 'RSS'#38388#38548'15'#20998#38047#65292#20063#21487#25163#21160#26356#26032
        end
        object infFindTimeRzSpinEdit: TRzSpinEdit
          Left = 129
          Top = 53
          Width = 56
          Height = 21
          Max = 100.000000000000000000
          Value = 1.000000000000000000
          TabOrder = 0
          OnChange = infFindTimeRzSpinEditChange
        end
        object pathFindTimeRzSpinEdit: TRzSpinEdit
          Left = 129
          Top = 21
          Width = 56
          Height = 21
          Max = 100.000000000000000000
          Value = 1.000000000000000000
          TabOrder = 1
          OnChange = pathFindTimeRzSpinEditChange
        end
        object subFindTimeRzSpinEdit: TRzSpinEdit
          Left = 321
          Top = 53
          Width = 53
          Height = 21
          Max = 100.000000000000000000
          Value = 1.000000000000000000
          TabOrder = 2
          OnChange = subFindTimeRzSpinEditChange
        end
      end
      object rg1: TRadioGroup
        Left = 496
        Top = 231
        Width = 393
        Height = 66
        Caption = #23383#24149#19979#36733#32593#31449#36873#25321
        Columns = 2
        Items.Strings = (
          'SubHD'
          #23383#24149#24211)
        TabOrder = 4
        OnClick = rg1Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 848
    Top = 600
    object N1: TMenuItem
      Caption = #21024#38500
      OnClick = N1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 784
    Top = 600
    object menuGetsrt: TMenuItem
      Caption = #33719#21462#23383#24149
      OnClick = menuGetsrtClick
    end
    object N2: TMenuItem
      Caption = #26356#26032#20449#24687
      OnClick = N2Click
    end
    object N7: TMenuItem
      Caption = #25163#24037#28155#21152
      OnClick = N7Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object N8: TMenuItem
      Caption = #21047#26032
      OnClick = N8Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #25773#25918
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = #25171#24320#30446#24405
      OnClick = N5Click
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object N10: TMenuItem
      Caption = #23383#24149#21516#21517
      OnClick = N10Click
    end
  end
  object RzLookupDialog1: TRzLookupDialog
    CaptionOK = 'OK'
    CaptionCancel = 'Cancel'
    CaptionHelp = '&Help'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Width = 475
    Left = 720
    Top = 600
  end
end
