unit Module;

interface

uses
  InterfaceModule, System.Generics.Collections, ClassParams, System.Rtti;

type
  TBaseModule = class(TInterfacedObject, IModule, IPreferences)
  strict private
    FObjectList  : TDictionary<TGUID, TClassParams>;
    FSigleton    : TDictionary<TGUID, IInterface>;
    FPreferences : TDictionary<string, string>;
    procedure RegisterClassInternal (p_GUID : TGUID; p_ClassParams : TClassParams);
    function CreateObjRTTI (const p_Class : TInterfacedClass; p_Args : array of TValue) : IInterface;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function GetModuleName : string; virtual;
    function OpenMainWindow : Integer; virtual;
    function OpenMainWindowInAddMode : Integer; virtual;
    function OpenModule : boolean; virtual;
    function CloseModule : boolean; virtual;
    function GetObjectList : TDictionary<TGUID, TClassParams>;
    function GiveObjectByInterface (p_GUID : TGUID) : IInterface; virtual;
    function GetSelfInterface : TGUID; virtual;
    function GetPreferences : TDictionary<string, string>;
    function GetPreference(const p_Key : string; const p_Default : string = '') : string;
    procedure SetPreference(const p_Key : string; const p_Value : string);
    function InterfaceExists (p_GUID : TGUID) : boolean;
    procedure RegisterClass (p_GUID : TGUID; p_Class : TInterfacedClass; const p_Args : array of TValue);
    procedure RegisterClassForSigleton(p_GUID : TGUID; p_Class : TInterfacedClass; const p_Args : array of TValue);
    procedure UnregisterClass (p_GUID : TGUID);
    procedure RegisterClasses; virtual;
  end;

implementation

uses
  System.SysUtils, System.UITypes;

{ TBaseModule }

function TBaseModule.CloseModule: boolean;
begin
  Result := True;
end;

constructor TBaseModule.Create;
begin
  FObjectList := TDictionary<TGUID, TClassParams>.Create;
  FSigleton   := TDictionary<TGUID, IInterface>.Create;
  FPreferences := TDictionary<string, string>.Create;

  RegisterClasses;
end;

function TBaseModule.CreateObjRTTI(const p_Class : TInterfacedClass; p_Args : array of TValue) : IInterface;
var
  pomContext : TRTTIContext;
  pomType    : TRTTIType;
const
  cConstructor = 'Create';
begin
  pomContext := TRttiContext.Create;
  pomType    := pomContext.GetType(p_Class);

  Result := pomType.GetMethod(cConstructor).Invoke(pomType.AsInstance.MetaclassType, p_Args).AsInterface;
end;

destructor TBaseModule.Destroy;
begin
  FreeAndNil (FSigleton);
  FreeAndNil (FObjectList);
  FreeAndNil (FPreferences);
  inherited;
end;

function TBaseModule.GetModuleName: string;
begin
  Result := 'Base Module';
end;

function TBaseModule.GetObjectList: TDictionary<TGUID, TClassParams>;
begin
  Result := FObjectList;
end;

function TBaseModule.GetPreference(const p_Key : string; const p_Default : string = '') : string;
begin
  if not FPreferences.TryGetValue(p_Key, Result) then
    Result := p_Default;
end;

function TBaseModule.GetPreferences: TDictionary<string, string>;
begin
  Result := FPreferences;
end;

function TBaseModule.GetSelfInterface: TGUID;
begin
  //to be covered in descendant
end;

function TBaseModule.GiveObjectByInterface(p_GUID: TGUID): IInterface;
var
  pomClass   : TClassParams;
begin
  if not FObjectList.TryGetValue (p_GUID, pomClass)
   then Exit (nil);

  if pomClass.FSigleton then
  begin
    if not FSigleton.TryGetValue(p_GUID, Result) then
    begin
      Result := CreateObjRTTI(pomClass.FInterfacedClass, pomClass.FArgs);
      FSigleton.Add(p_GUID, Result);
    end
  end
  else
    Result := CreateObjRTTI(pomClass.FInterfacedClass, pomClass.FArgs);
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

procedure TBaseModule.RegisterClass(p_GUID : TGUID; p_Class : TInterfacedClass; const p_Args : array of TValue);
var
  pomClassParams : TClassParams;
begin
  pomClassParams := TClassParams.Create(p_Class, p_Args);
  RegisterClassInternal(p_GUID, pomClassParams);
end;

procedure TBaseModule.RegisterClasses;
begin
  //to be covered in descendant
end;

procedure TBaseModule.RegisterClassForSigleton(p_GUID : TGUID; p_Class : TInterfacedClass; const p_Args : array of TValue);
var
  pomClassParams : TClassParams;
begin
  pomClassParams := TClassParams.Create(p_Class, p_Args, true);
  RegisterClassInternal(p_GUID, pomClassParams);
end;

procedure TBaseModule.RegisterClassInternal(p_GUID: TGUID;
  p_ClassParams: TClassParams);
begin
  if not Supports(p_ClassParams.FInterfacedClass, p_GUID) then
    raise Exception.Create(Format ('Klasa %s nie implemetuje interfejsu %s', [p_ClassParams.FInterfacedClass.ClassName, GUIDToString (p_GUID)]));
  if FObjectList.ContainsKey (p_GUID) then
    raise Exception.Create(Format ('W j¹drze jest ju¿ zarejestrowany interfejs %s', [GUIDToString (p_GUID)]));

  FObjectList.Add (p_GUID, p_ClassParams);
end;

procedure TBaseModule.SetPreference(const p_Key, p_Value: string);
begin
  FPreferences.Add(p_Key, p_Value);
end;

procedure TBaseModule.UnregisterClass (p_GUID: TGUID);
begin
  FObjectList.Remove (p_GUID);
end;

end.
