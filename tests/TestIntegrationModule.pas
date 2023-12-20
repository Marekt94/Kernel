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
  end;

implementation

uses
  InterfaceModule, INIPreferenceRepository, Module, System.SysUtils,
  System.Generics.Collections;

const
  cINIPath = '..\..\test_preferences.ini';
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

procedure TTestIntegrationModule.Setup;
begin
  FPreferences := TPreferenceRepository.Create;
end;

procedure TTestIntegrationModule.TearDown;
begin
  FPreferences := nil;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestIntegrationModule);

end.
