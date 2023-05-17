unit InterfaceKernel;

interface

uses
  InterfaceModule, System.Generics.Collections;

type
  TKernelState = (ks_Loading, ks_Ready);

  IContainer = interface
  ['{3F76C9A4-0DA3-4EE4-AABC-F47A5C4C1D50}']
    procedure RegisterModules (p_ModuleList : TList<IModule>);
    procedure SetContainer (p_Container : IContainer);
    property Container : IContainer write SetContainer;
  end;

  IMainKernel = interface
  ['{1E3557B2-0A30-4880-8639-3F8A57295AEE}']
    procedure OpenModules;
    procedure CloseModules;
    procedure ReloadModules;
    procedure Open;
    procedure Close;
    function GiveObjectByInterface (p_GUID : TGUID; p_Silent : boolean = false) : IInterface;
    function GetState : TKernelState;
    function GetMainContainer : IContainer;
    property State : TKernelState read GetState;
    property MainContainer : IContainer read GetMainContainer;
  end;

implementation

end.
