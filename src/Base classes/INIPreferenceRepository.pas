unit INIPreferenceRepository;

interface

uses
  InterfaceKernel, InterfaceModule, System.Generics.Collections, System.IniFiles;

const
  PREFERENCES_NOT_LOADED = 'Preferences haven''t been loaded. Saving preferences before loading is prohibited';

type
  TPreferenceRepository = class(TInterfacedObject, IPreferenceRepository)
  private
    FINIFile : TMemIniFIle;
  public
    destructor Destroy; override;
    procedure LoadPreferences(const p_Path : string);
    procedure FillPreferences(p_Module : IModule);
    procedure SavePreferences(p_ModuleList : TList<IModule>);
  end;

implementation

uses
  System.SysUtils, System.Classes,System.StrUtils;

{ TPreferenceRepository }

destructor TPreferenceRepository.Destroy;
begin
  FINIFile.Free;
  inherited;
end;

procedure TPreferenceRepository.FillPreferences(p_Module: IModule);
var
  pomPrefs : IPreferences;
  pomPrefsList : TStringList;
begin
  if Supports(p_Module, IPreferences, pomPrefs) then
  begin
    pomPrefsList := TStringList.Create;
    try
      FINIFile.ReadSectionValues(p_Module.GetModuleName, pomPrefsList);
      for var i := 0 to pomPrefsList.Count - 1 do
        pomPrefs.SetPreference(pomPrefsList.Names[i], pomPrefsList.ValueFromIndex[i]);
    finally
      pomPrefsList.Free;
    end;
  end;
end;

procedure TPreferenceRepository.LoadPreferences(const p_Path : string);
var
  pomPath : string;
begin
  if Assigned(FINIFile) then
    FINIFile.Free;

  if Trim(p_Path) = '' then
    pomPath := 'preferences.ini'
  else
    pomPath := p_Path;

  FINIFile := TMemIniFile.Create(pomPath);
end;

procedure TPreferenceRepository.SavePreferences(p_ModuleList: TList<IModule>);
var
  pomPreferences : IPreferences;
begin
  if not Assigned(FINIFile) then
    raise Exception.Create(PREFERENCES_NOT_LOADED);

  for var pomModule in p_ModuleList do
    if Supports(pomModule, IPreferences, pomPreferences) then
      for var pomPreference in pomPreferences.Preferences do
        FINIFile.WriteString(pomModule.GetModuleName, pomPreference.Key, pomPreference.Value);

  FINIFile.UpdateFile;
end;

end.
