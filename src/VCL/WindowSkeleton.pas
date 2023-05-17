unit WindowSkeleton;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls;

const
  WM_AFTERSHOW = WM_USER + 1;

type
  TWndSkeleton = class(TForm)
    pnlMain: TPanel;
    lblTitle: TLabel;
    pnlNavigationKeys: TPanel;
    btnCancel: TButton;
    btnOk: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AfterShowReact (var Msg: TMessage); message WM_AFTERSHOW;
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  strict private
    FChildPanel : TFrame;
    FAfterShow : TProc;
  public
    destructor Destroy; override;
    function Init (p_ChildPanel : TFrame;
                   p_Title      : string;
                   p_WithNavigationKeys : boolean = true;
                   p_FullScreen : Boolean = false) : TForm; virtual;
    property AfterShow: TProc read FAfterShow write FAfterShow;
  end;

implementation

uses
  InterfaceBasePanel;

{$R *.dfm}

{ TWndSkeleton }

procedure TWndSkeleton.AfterShowReact(var Msg: TMessage);
begin
  if Assigned (FAfterShow) then
    FAfterShow;
end;

procedure TWndSkeleton.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  CloseModal;
end;

procedure TWndSkeleton.btnOkClick(Sender: TObject);
begin
  if Assigned(FChildPanel.GetInterfaceEntry(IBasePanelValidator)) and not (FChildPanel as IBasePanelValidator).Check then
    Exit;

  ModalResult := mrOk;
  CloseModal;
end;

destructor TWndSkeleton.Destroy;
begin
  FChildPanel.Parent := nil;
  inherited;
end;

procedure TWndSkeleton.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then
  begin
    ModalResult := mrCancel;
    Close;
  end;
end;

procedure TWndSkeleton.FormShow(Sender: TObject);
begin
  PostMessage(Handle, WM_AFTERSHOW, 0, 0);
end;

//function creating basic window
function TWndSkeleton.Init (p_ChildPanel : TFrame;
                   p_Title      : string;
                   p_WithNavigationKeys : boolean = true;
                   p_FullScreen : Boolean = false) : TForm;
var
  pomWidth : Integer;
begin
  FChildPanel := p_ChildPanel;
  FChildPanel.Parent := pnlMain;
  FChildPanel.Align  := alClient;
  Caption := p_Title;
  if p_FullScreen then
    WindowState := wsMaximized
  else
  begin
    var pomLblTextWidth := lblTitle.Canvas.TextWidth (p_Title) + 100;
    if FChildPanel.Width > pomLblTextWidth then
      pomWidth := FChildPanel.Width
    else
      pomWidth := pomLblTextWidth;
    pnlMain.Height := FChildPanel.Height;
    ClientWidth    := pomWidth;
    ClientHeight   := lblTitle.Height + FChildPanel.Height + pnlNavigationKeys.Height;
  end;
  if not p_WithNavigationKeys then
    pnlNavigationKeys.Height := 0;
  lblTitle.Caption   := p_Title;

  Result := self;
end;

end.
