unit ControllerWithParameters;

interface

type
  IControllerWithParameterString = interface
    ['{4A54DAF0-CF61-4C1F-90C6-44D02D08FC22}']
    function GetTEstParam : string;
    property TestParam: string read GetTestParam;
  end;

  TControllerWithParameterString = class(TInterfacedObject, IControllerWithParameterString)
  strict private
    FTestParam : string;
  public
    constructor Create(const p_TestParam : string); overload;
    function GetTEstParam : string;
    property TestParam: string read GetTestParam;
  end;

  IControllerWithParameterInt = interface
  ['{36EF3B84-1C11-40BD-8D3A-03780615BC77}']
    function GetTEstParam : Integer;
    property TestParam: Integer read GetTestParam;
  end;

  TControllerWithParameterInt = class(TInterfacedObject, IControllerWithParameterInt)
  strict private
    FTestParam : Integer;
  public
    constructor Create(const p_TestParam : Integer); overload;
    function GetTEstParam : Integer;
    property TestParam: Integer read GetTestParam;
  end;

implementation

{ TControllerWithParameters }

constructor TControllerWithParameterString.Create(const p_TestParam: string);
begin
  FTestParam := p_TestParam;
end;

function TControllerWithParameterString.GetTEstParam: string;
begin
  Result := FTestParam;
end;

{ TControllerWithParameterInt }

constructor TControllerWithParameterInt.Create(const p_TestParam: Integer);
begin
  FTestParam := p_TestParam;
end;

function TControllerWithParameterInt.GetTEstParam: Integer;
begin
  Result := FTestParam;
end;

end.
