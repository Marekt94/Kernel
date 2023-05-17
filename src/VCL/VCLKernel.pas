unit VCLKernel;

interface

uses
  InterfaceVCLKernel, InterfaceKernel, Kernel;

type
  TVCLKernel = class(TInterfacedObject, IVCLKernel)
  strict private
    FKernel : IMainKernel;
  public
    constructor Create(p_BaseKernel : IContainer);
    procedure OpenModules;
    procedure CloseModules;
    procedure ReloadModules;
    procedure Open(p_MainFrame : TFrameClass; p_FrameTitle : string); overload;
    procedure Open; overload;
    procedure Close;
    function GiveObjectByInterface (p_GUID : TGUID; p_Silent : boolean = false) : IInterface;
    function GetState : TKernelState;
    function GetMainContainer : IContainer;
    property State : TKernelState read GetState;
    property MainContainer : IContainer read GetMainContainer;
  end;

implementation

uses
  WindowSkeleton, System.SysUtils;

{ TVCLKernel }

procedure TVCLKernel.Close;
begin
  FKernel.Close;
end;

procedure TVCLKernel.CloseModules;
begin
  FKernel.CloseModules;
end;

constructor TVCLKernel.Create(p_BaseKernel : IContainer);
begin
  FKernel := TKernel.Create(p_BaseKernel);
end;

function TVCLKernel.GetMainContainer: IContainer;
begin
  Result := FKernel.GetMainContainer;
end;

function TVCLKernel.GetState: TKernelState;
begin
  Result := FKernel.GetState;
end;

function TVCLKernel.GiveObjectByInterface(p_GUID: TGUID;
  p_Silent: boolean): IInterface;
begin
  Result := FKErnel.GiveObjectByInterface(p_GUID, p_Silent);
end;

procedure TVCLKernel.Open(p_MainFrame: TFrameClass; p_FrameTitle: string);
var
  pomWind : TWndSkeleton;
begin
  FKernel.Open;
  pomWind := TWndSkeleton.Create(nil);
  try
    pomWind.Init (p_MainFrame.Create (pomWind), p_FrameTitle, false, false);
    pomWind.ShowModal;
  finally
    FreeAndNil (pomWind);
  end;
end;

procedure TVCLKernel.Open;
begin
  FKernel.Open
end;

procedure TVCLKernel.OpenModules;
begin
  FKernel.OpenModules;
end;

procedure TVCLKernel.ReloadModules;
begin
  FKernel.ReloadModules;
end;

end.
