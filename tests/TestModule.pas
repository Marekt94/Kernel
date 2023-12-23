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
    [Test]
    procedure GetObjectWithInitParameterString;
    [Test]
    procedure GetObjectWithInitParameterInteger;
    [Test]
    procedure GetSingletonWithInitParameterString;
    [Test]
    procedure GetSingletonWithInitParameterInteger;
  end;

implementation

uses
  Singleton, ControllerWithParameters;

procedure TTestModule.GetEmptyWhenNoPreference;
begin
  var pomModule := TBaseModule.Create;

  Assert.AreEqual('', pomModule.GetPreference('key'));
end;

procedure TTestModule.GetObjectWithInitParameterInteger;
const
  cTestValue = 12;
begin
  var pomModule := TBaseModule.Create;
  pomModule.RegisterClass(ICOntrollerWithParameterInt, TControllerWithParameterInt, [cTestValue]);

  var pomObj := pomModule.GiveObjectByInterface(ICOntrollerWithParameterInt) as ICOntrollerWithParameterInt;
  Assert.AreEqual(cTestValue, pomObj.TestParam);
end;

procedure TTestModule.GetObjectWithInitParameterString;
const
  cTestValue = 'test_value';
begin
  var pomModule := TBaseModule.Create;
  pomModule.RegisterClass(ICOntrollerWithParameterString, TControllerWithParameterString, [cTestValue]);

  var pomObj := pomModule.GiveObjectByInterface(ICOntrollerWithParameterString) as ICOntrollerWithParameterString;
  Assert.AreEqual(cTestValue, pomObj.TestParam);
end;

procedure TTestModule.GetProperPreference;
begin
  var pomModule := TBaseModule.Create;
  pomModule.SetPreference('key', 'value');
  Assert.AreEqual('value', pomModule.GetPreference('key'));
end;

procedure TTestModule.GetSingletonWithInitParameterInteger;
const
  cTestValue = 12;
begin
  var pomModule := TBaseModule.Create;
  pomModule.RegisterClassForSigleton(ICOntrollerWithParameterInt, TControllerWithParameterInt, [cTestValue]);

  var pomObj := pomModule.GiveObjectByInterface(ICOntrollerWithParameterInt) as ICOntrollerWithParameterInt;
  Assert.AreEqual(cTestValue, pomObj.TestParam);
end;

procedure TTestModule.GetSingletonWithInitParameterString;
const
  cTestValue = 'test_value';
begin
  var pomModule := TBaseModule.Create;
  pomModule.RegisterClassForSigleton(ICOntrollerWithParameterString, TControllerWithParameterString, [cTestValue]);

  var pomObj := pomModule.GiveObjectByInterface(ICOntrollerWithParameterString) as ICOntrollerWithParameterString;
  Assert.AreEqual(cTestValue, pomObj.TestParam);
end;

procedure TTestModule.RegiesterClassNormal;
const
  cExpectedValue = 0;
  cGivenValue    = 7;
begin
  var pomModule := TBaseModule.Create;
  pomModule.RegisterClass(IClassForSigletonTest, TClassForSigletonTest, []);

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
  pomModule.RegisterClassForSigleton(IClassForSigletonTest, TClassForSigletonTest, []);

  var pomSingleton := pomModule.GiveObjectByInterface(IClassForSigletonTest) as IClassForSigletonTest;
  pomSingleton.TestField := cGivenValue;

  pomSingleton := nil;
  pomSingleton := pomModule.GiveObjectByInterface(IClassForSigletonTest) as IClassForSigletonTest;

  Assert.AreEqual(cExpectedValue, pomSingleton.TestField);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestModule);

end.
