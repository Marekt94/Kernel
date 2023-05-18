unit Module;

interface

uses
  InterfaceModule, System.Generics.Collections;

type
  TBaseModule = class(TInterfacedObject, IModule)
  strict private
    FObjectList :  TDictionary<TGUID, TInterfacedClass>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function OpenMainWindow : Integer; virtual;
    function OpenMainWindowInAddMode : Integer; virtual;
    function OpenModule : boolean; virtual;
    function CloseModule : boolean; virtual;
    function GetObjectList : TDictionary<TGUID, TInterfacedClass>;
    function GiveObjectByInterface (p_GUID : TGUID) : IInterface; virtual;
    function GetSelfInterface : TGUID; virtual;
    function InterfaceExists (p_GUID : TGUID) : boolean;
    procedure RegisterClass (p_GUID : TGUID; p_Class : TInterfacedClass);
    procedure UnregisterClass (p_GUID : TGUID);
    procedure RegisterClasses; virtual;
  end;

implementation

uses
  System.SysUtils, System.UITypes, System.Rtti;

{ TBaseModule }

function TBaseModule.CloseModule: boolean;
begin
  Result := True;
end;

constructor TBaseModule.Create;
begin
  FObjectList := TDictionary<TGUID, TInterfacedClass>.Create;

  RegisterClasses;
end;

destructor TBaseModule.Destroy;
begin
  FreeAndNil (FObjectList);
  inherited;
end;

function TBaseModule.GetObjectList: TDictionary<TGUID, TInterfacedClass>;
begin
  Result := FObjectList;
end;

function TBaseModule.GetSelfInterface: TGUID;
begin
  //to be covered in descendant
end;

function TBaseModule.GiveObjectByInterface(p_GUID: TGUID): IInterface;
var
  pomClass : TInterfacedClass;
  pomContext : TRTTIContext;
  pomType    : TRTTIType;
const
  cConstructor = 'Create';
begin
  if not FObjectList.TryGetValue (p_GUID, pomClass)
   then Exit (nil);

  pomContext := TRttiContext.Create;
  pomType    := pomContext.GetType(pomClass);

  Result := pomType.GetMethod(cConstructor).Invoke(pomType.AsInstance.MetaclassType, []).AsInterface;
end;

function TBaseModule.InterfaceExists(p_GUID: TGUID): boolean;
begin
  Result := FObjectList.ContainsKey(p_GUID);
end;

function TBaseModule.OpenMainWindow: Integer;
begin
  Result := mrOk
end;

function TBaseModule.OpenMainWindowInAddMode: Integer;
begin
  Result := mrOk;
end;

function TBaseModule.OpenModule: boolean;
begin
  Result := true;
end;

procedure TBaseModule.RegisterClass(p_GUID : TGUID; p_Class : TInterfacedClass);
begin
  if not Supports(p_Class, p_GUID) then
    raise Exception.Create(Format ('Klasa %s nie implemetuje interfejsu %s', [p_Class.ClassName, GUIDToString (p_GUID)]));
  if FObjectList.ContainsKey (p_GUID) then
    raise Exception.Create(Format ('W j¹drze jest ju¿ zarejestrowany interfejs %s', [GUIDToString (p_GUID)]));
  FObjectList.Add (p_GUID, p_Class);
end;

procedure TBaseModule.RegisterClasses;
begin
  //to be covered in descendant
end;

procedure TBaseModule.UnregisterClass (p_GUID: TGUID);
begin
  FObjectList.Remove (p_GUID);
end;

end.
