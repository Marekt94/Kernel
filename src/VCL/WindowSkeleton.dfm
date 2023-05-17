object WndSkeleton: TWndSkeleton
  Left = 0
  Top = 0
  Caption = 'WndSkeleton'
  ClientHeight = 424
  ClientWidth = 785
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblTitle: TLabel
    Left = 0
    Top = 0
    Width = 785
    Height = 42
    Align = alTop
    Alignment = taCenter
    Caption = 'lblTitle'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 106
  end
  object pnlMain: TPanel
    Left = 0
    Top = 42
    Width = 785
    Height = 341
    Align = alClient
    TabOrder = 0
  end
  object pnlNavigationKeys: TPanel
    Left = 0
    Top = 383
    Width = 785
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      785
      41)
    object btnCancel: TButton
      Left = 696
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Anuluj'
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnOk: TButton
      Left = 615
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Ok'
      TabOrder = 1
      OnClick = btnOkClick
    end
  end
end
