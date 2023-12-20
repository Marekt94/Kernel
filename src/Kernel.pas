unit Kernel;

interface

uses
  InterfaceModule, System.Generics.Collections, InterfaceKernel, BaseKernel;

type
  TKernel = class (TInterfacedObject, IMainKernel)
    strict private
      FObjectList : TList<IModule>;
      FContainer : IContainer;
      FPreferenceRepository : IPreferenceRepository;
    protected
      FState : TKernelState;
    public
      constructor Create (p_BaseKernel : IContainer);
      destructor Destroy; override;
      procedure OpenModules; virtual;
      procedure CloseModules; virtual;
      procedure ReloadModules; virtual;
      procedure Open;
      procedure Close;
      procedure SetPreferencesRepository(const p_Value : IPreferenceRepository);
      function GetPreferencesRepository : IPreferenceRepository;
      function GiveObjectByInterface (p_GUID : TGUID; p_Silent : boolean = false) : IInterface;
      function GetState : TKernelState;
      function GetMainContainer : IContainer;
  end;

implementation

uses
  System.SysUtils;

{ TKernel }

procedure TKernel.Close;
begin
  CloseModules;
end;

procedure TKernel.CloseModules;
begin
  if Assigned(FPreferenceRepository) then
    FPreferenceRepository.SavePreferences(FObjectList);

  for var pomModule in FObjectList do
    pomModule.CloseModule;
end;

constructor TKernel.Create (p_BaseKernel : IContainer);
begin
  FObjectList := TList<IModule>.Create;
  FContainer := p_BaseKernel;
end;

destructor TKernel.Destroy;
begin
  FreeAndNil(FObjectList);
  inherited;
end;

function TKernel.GetMainContainer: IContainer;
begin
  Result := FContainer;
end;

function TKernel.GetPreferencesRepository: IPreferenceRepository;
begin
  Result := FPreferenceRepository;
end;

function TKernel.GetState: TKernelState;
begin
  Result := FState;
end;

procedure TKernel.OpenModules;
begin
  if Assigned(FPreferenceRepository) then
    FPreferenceRepository.LoadPreferences;
  for var pomModule in FObjectList do
  begin
    pomModule.OpenModule;
    if Assigned(FPreferenceRepository) then
      FPreferenceRepository.FillPreferences(pomModule);
  end;
end;

procedure TKernel.ReloadModules;
begin
  CloseModules;
  OpenModules;
end;

procedure TKernel.SetPreferencesRepository(
  const p_Value: IPreferenceRepository);
begin
  FPreferenceRepository := p_Value;
end;

procedure TKernel.Open;
begin
  FState := ks_Loading;

  if not Assigned (FContainer) then
    Exit;
  FContainer.RegisterModules (FObjectList);
  OpenModules;
  FState := ks_Ready;
end;
//------------------------------------------------------------------------------
function TKernel.GiveObjectByInterface(p_GUID: TGUID; p_Silent : boolean): IInterface;
resourcestring
  rs_no_interface = 'Brak interfejsu';
begin
  Result := nil;

  for var pomModule in FObjectList do
  begin
    if pomModule.SelfInterface = p_GUID then
      Exit (pomModule)
    else
    begin
      Result := pomModule.GiveObjectByInterface (p_GUID);
      if Assigned (Result) then
        Exit;
    end
  end;

  Result := nil;
  if not p_Silent then
    raise Exception.Create(rs_no_interface);
end;

end.
