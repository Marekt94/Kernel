unit TestIntegrationModule;

interface

uses
  DUnitX.TestFramework, InterfaceKernel;

type
  [TestFixture]
  TTestIntegrationModule = class
  private
    FPreferences : IPreferenceRepository;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure LoadPreferences;
    [Test]
    procedure SavePreferences;
    [Test]
    procedure SavePreferencesWhenEmptyFile;
    [Test]
    procedure RasieExceptionWhenSavePreferencesWithoutLoad;
  end;

implementation

uses
  InterfaceModule, INIPreferenceRepository, Module, System.SysUtils,
  System.Generics.Collections, System.IOUtils;

const
  cINIPathSource = '..\..\test_preferences.ini';
  cINIPath = '..\..\test_preferences.ini.temp';
  cTestKey = 'test_key';
  cTestValue = 'test_value';

procedure TTestIntegrationModule.LoadPreferences;
var
  pomModule : IModule;
  pomPreference : IPreferences;
  pomValue : string;
begin
  FPreferences.LoadPreferences(cINIPath);
  pomModule := TBaseModule.Create;
  FPreferences.FillPreferences(pomModule);
  Supports(pomModule, IPreferences, pomPreference);
  pomValue := pomPreference.GetPreference(cTestKey);
  Assert.AreEqual(cTestValue, pomValue);
end;

procedure TTestIntegrationModule.RasieExceptionWhenSavePreferencesWithoutLoad;
var
  pomModule : IModule;
  pomPreference : IPreferences;
begin
  pomModule := TBaseModule.Create;
  Supports(pomModule, IPreferences, pomPreference);
  pomPreference.SetPreference(cTestKey + '2', cTestValue + '2');

  var pomList := TList<IModule>.Create;
  pomList.Add(pomModule);

  Assert.WillRaiseWithMessage(procedure
  begin
    FPreferences.SavePreferences(pomList);
  end, nil, PREFERENCES_NOT_LOADED);
end;

procedure TTestIntegrationModule.SavePreferences;
var
  pomModule : IModule;
  pomPreference : IPreferences;
  pomValue : string;
begin
  FPreferences.LoadPreferences(cINIPath);
  pomModule := TBaseModule.Create;
  FPreferences.FillPreferences(pomModule);
  Supports(pomModule, IPreferences, pomPreference);
  pomPreference.SetPreference(cTestKey + '2', cTestValue + '2');

  var pomList := TList<IModule>.Create;
  pomList.Add(pomModule);

  FPreferences.SavePreferences(pomList);

  FPreferences := nil;
  FPreferences := TPreferenceRepository.Create;
  FPreferences.LoadPreferences(cINIPath);
  pomModule := TBaseModule.Create;
  FPreferences.FillPreferences(pomModule);
  Supports(pomModule, IPreferences, pomPreference);
  pomValue := pomPreference.GetPreference(cTestKey + '2');
  Assert.AreEqual(cTestValue + '2', pomValue);
end;

procedure TTestIntegrationModule.SavePreferencesWhenEmptyFile;
var
  pomModule : IModule;
  pomPreference : IPreferences;
  pomValue : string;
  pomTextFile : TextFile;
begin
  AssignFile(pomTextFile, cINIPath);
  Rewrite(pomTextFile);
  CloseFile(pomTextFile);

  FPreferences.LoadPreferences(cINIPath);
  pomModule := TBaseModule.Create;
  FPreferences.FillPreferences(pomModule);
  Supports(pomModule, IPreferences, pomPreference);
  pomPreference.SetPreference(cTestKey + '2', cTestValue + '2');

  var pomList := TList<IModule>.Create;
  pomList.Add(pomModule);

  FPreferences.SavePreferences(pomList);

  FPreferences := nil;
  FPreferences := TPreferenceRepository.Create;
  FPreferences.LoadPreferences(cINIPath);
  pomModule := TBaseModule.Create;
  FPreferences.FillPreferences(pomModule);
  Supports(pomModule, IPreferences, pomPreference);
  pomValue := pomPreference.GetPreference(cTestKey + '2');
  Assert.AreEqual(cTestValue + '2', pomValue);
end;

procedure TTestIntegrationModule.Setup;
begin
  FPreferences := TPreferenceRepository.Create;
  TFile.Copy(cINIPathSource, cINIPath, true);
end;

procedure TTestIntegrationModule.TearDown;
begin
  FPreferences := nil;
  TFile.Delete(cINIPath);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestIntegrationModule);

end.
