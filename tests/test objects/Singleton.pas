unit Singleton;

interface

uses
  Module;

type
  IClassForSigletonTest = interface(IInterface)
    ['{E756DA72-498C-4422-BE55-44417BF2A58D}']
    function GetTestField : Integer;
    procedure SetTestField(const Value: Integer);
    property TestField: Integer read GetTestField write SetTestField;
  end;

  TClassForSigletonTest = class(TInterfacedObject, IClassForSigletonTest)
  strict private
    FTestField : Integer;
  public
    function GetTestField : Integer;
    procedure SetTestField(const Value: Integer);
    property TestField: Integer read GetTestField write SetTestField;
  end;

implementation

{ TClassForSigletonTest }

function TClassForSigletonTest.GetTestField: Integer;
begin
  Result := FTestField;
end;

procedure TClassForSigletonTest.SetTestField(const Value: Integer);
begin
  FTestField := Value;
end;

end.
