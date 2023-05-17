unit InterfaceModule;

interface

uses
  System.Generics.Collections;

type
  IModule = interface (IInterface)
  ['{1C342A88-4427-435B-82EF-737C925AFE7F}']
    function GetSelfInterface : TGUID;
    function GetObjectList : TDictionary<TGUID, TInterfacedClass>;
    function GiveObjectByInterface (p_GUID : TGUID) : IInterface;
    function InterfaceExists (p_GUID : TGUID) : boolean;
    function OpenModule : boolean;
    function CloseModule : boolean;
    function OpenMainWindow : Integer;
    function OpenMainWindowInAddMode : Integer;
    procedure RegisterClass (p_GUID : TGUID; p_Class : TInterfacedClass);
    procedure UnregisterClass (p_GUID : TGUID);
    procedure RegisterClasses;
    property ObjectList: TDictionary<TGUID, TInterfacedClass> read GetObjectList;
    property SelfInterface : TGUID read GetSelfInterface;
  end;

implementation

end.
