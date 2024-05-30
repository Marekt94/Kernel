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
    function GetVersion : Double;
    property Container : IContainer write SetContainer;
    property Version : Double read GetVersion;
  end;

  IPreferenceRepository = interface
  ['{7654ADB3-C109-4ACE-9D94-B00C12B82339}']
    procedure LoadPreferences(const p_Path : string = '');
    procedure FillPreferences(p_Module : IModule);
    procedure SavePreferences(p_ModuleList : TList<IModule>);
  end;

  IMainKernel = interface
  ['{1E3557B2-0A30-4880-8639-3F8A57295AEE}']
    procedure OpenModules;
    procedure CloseModules;
    procedure ReloadModules;
    procedure Open;
    procedure Close;
    function GetPreferencesRepository : IPreferenceRepository;
    procedure SetPreferencesRepository(const p_Value : IPreferenceRepository);
    function GiveObjectByInterface (p_GUID : TGUID; p_Silent : boolean = false) : IInterface;
    function GetState : TKernelState;
    function GetMainContainer : IContainer;
    property State : TKernelState read GetState;
    property MainContainer : IContainer read GetMainContainer;
    property PreferenceRepository : IPreferenceRepository read GetPreferencesRepository write SetPreferencesRepository;
  end;

var
  MainKernel : IMainKernel;

implementation

end.
