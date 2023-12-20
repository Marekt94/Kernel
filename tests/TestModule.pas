unit TestModule;

interface

uses
  DUnitX.TestFramework, Module;

type
  [TestFixture]
  TTestModule = class
  public
    [Test]
    procedure RegisterSigleton;
    [Test]
    procedure RegiesterClassNormal;
    [Test]
    procedure GetEmptyWhenNoPreference;
    [Test]
    procedure GetProperPreference;
  end;

implementation

uses
  Singleton;

procedure TTestModule.GetEmptyWhenNoPreference;
begin
  var pomModule := TBaseModule.Create;

  Assert.AreEqual('', pomModule.GetPreference('key'));
end;

procedure TTestModule.GetProperPreference;
begin
  var pomModule := TBaseModule.Create;
  pomModule.SetPreference('key', 'value');
  Assert.AreEqual('value', pomModule.GetPreference('key'));
end;

procedure TTestModule.RegiesterClassNormal;
const
  cExpectedValue = 0;
  cGivenValue    = 7;
begin
  var pomModule := TBaseModule.Create;
  pomModule.RegisterClass(IClassForSigletonTest, TClassForSigletonTest);

  var pomSingleton := pomModule.GiveObjectByInterface(IClassForSigletonTest) as IClassForSigletonTest;
  pomSingleton.TestField := cGivenValue;

  pomSingleton := nil;
  pomSingleton := pomModule.GiveObjectByInterface(IClassForSigletonTest) as IClassForSigletonTest;

  Assert.AreEqual(cExpectedValue, pomSingleton.TestField);
end;

procedure TTestModule.RegisterSigleton;
const
  cExpectedValue = 7;
  cGivenValue    = 7;
begin
  var pomModule := TBaseModule.Create;
  pomModule.RegisterClassForSigleton(IClassForSigletonTest, TClassForSigletonTest);

  var pomSingleton := pomModule.GiveObjectByInterface(IClassForSigletonTest) as IClassForSigletonTest;
  pomSingleton.TestField := cGivenValue;

  pomSingleton := nil;
  pomSingleton := pomModule.GiveObjectByInterface(IClassForSigletonTest) as IClassForSigletonTest;

  Assert.AreEqual(cExpectedValue, pomSingleton.TestField);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestModule);

end.
