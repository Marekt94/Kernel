unit Module;

interface

uses
  InterfaceModule, System.Generics.Collections, ClassParams;

type
  TBaseModule = class(TInterfacedObject, IModule)
  strict private
    FObjectList :  TDictionary<TGUID, TClassParams>;
    FSigleton   :  TDictionary<TGUID, IInterface>;
    procedure RegisterClassInternal (p_GUID : TGUID; p_ClassParams : TClassParams);
    function CreateObjRTTI (const p_Class : TInterfacedClass) : IInterface;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function OpenMainWindow : Integer; virtual;
    function OpenMainWindowInAddMode : Integer; virtual;
    function OpenModule : boolean; virtual;
    function CloseModule : boolean; virtual;
    function GetObjectList : TDictionary<TGUID, TClassParams>;
    function GiveObjectByInterface (p_GUID : TGUID) : IInterface; virtual;
    function GetSelfInterface : TGUID; virtual;
    function InterfaceExists (p_GUID : TGUID) : boolean;
    procedure RegisterClass (p_GUID : TGUID; p_Class : TInterfacedClass);
    procedure RegisterClassForSigleton(p_GUID : TGUID; p_Class : TInterfacedClass);
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
  FObjectList := TDictionary<TGUID, TClassParams>.Create;
  FSigleton   := TDictionary<TGUID, IInterface>.Create;

  RegisterClasses;
end;

function TBaseModule.CreateObjRTTI(const p_Class: TInterfacedClass): IInterface;
var
  pomContext : TRTTIContext;
  pomType    : TRTTIType;
const
  cConstructor = 'Create';
begin
  pomContext := TRttiContext.Create;
  pomType    := pomContext.GetType(p_Class);

  Result := pomType.GetMethod(cConstructor).Invoke(pomType.AsInstance.MetaclassType, []).AsInterface;
end;

destructor TBaseModule.Destroy;
begin
  FreeAndNil (FSigleton);
  FreeAndNil (FObjectList);
  inherited;
end;

function TBaseModule.GetObjectList: TDictionary<TGUID, TClassParams>;
begin
  Result := FObjectList;
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
      Result := CreateObjRTTI(pomClass.FInterfacedClass);
      FSigleton.Add(p_GUID, Result);
    end
  end
  else
    Result := CreateObjRTTI(pomClass.FInterfacedClass);
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
var
  pomClassParams : TClassParams;
begin
  pomClassParams := TClassParams.Create(p_Class);
  RegisterClassInternal(p_GUID, pomClassParams);
end;

procedure TBaseModule.RegisterClasses;
begin
  //to be covered in descendant
end;

procedure TBaseModule.RegisterClassForSigleton(p_GUID: TGUID;
  p_Class: TInterfacedClass);
var
  pomClassParams : TClassParams;
begin
  pomClassParams := TClassParams.Create(p_Class, true);
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

procedure TBaseModule.UnregisterClass (p_GUID: TGUID);
begin
  FObjectList.Remove (p_GUID);
end;

end.
