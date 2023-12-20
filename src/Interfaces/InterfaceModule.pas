unit InterfaceModule;

interface

uses
  System.Generics.Collections, ClassParams;

type
  IModule = interface (IInterface)
  ['{1C342A88-4427-435B-82EF-737C925AFE7F}']
    function GetModuleName : string;
    function GetSelfInterface : TGUID;
    function GetObjectList : TDictionary<TGUID, TClassParams>;
    function GiveObjectByInterface (p_GUID : TGUID) : IInterface;
    function InterfaceExists (p_GUID : TGUID) : boolean;
    function OpenModule : boolean;
    function CloseModule : boolean;
    function OpenMainWindow : Integer;
    function OpenMainWindowInAddMode : Integer;
    procedure RegisterClass (p_GUID : TGUID; p_Class : TInterfacedClass);
    procedure RegisterClassForSigleton(p_GUID : TGUID; p_Class : TInterfacedClass);
    procedure UnregisterClass (p_GUID : TGUID);
    procedure RegisterClasses;
    property ObjectList: TDictionary<TGUID, TClassParams> read GetObjectList;
    property SelfInterface : TGUID read GetSelfInterface;
  end;

  IPreferences = interface(IInterface)
  ['{E5270C72-B519-46FA-B4D0-6FB6CAAC6F3D}']
    function GetPreferences : TDictionary<string, string>;
    function GetPreference(const p_Key : string) : string;
    procedure SetPreference(const p_Key : string; const p_Value : string);
    property Preferences : TDictionary<string, string> read GetPreferences;
  end;

implementation

end.
