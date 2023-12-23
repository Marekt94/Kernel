unit ClassParams;

interface

uses
  System.Rtti;

type
  TClassParams = record
    FSigleton : boolean;
    FInterfacedClass : TInterfacedClass;
    FLazyLoad : boolean;
    FArgs : array of TValue;

    constructor Create(const p_Class : TInterfacedClass;
                             p_Args  : array of TValue;
                             p_Sigleton : boolean = false;
                             p_LazyLoad : boolean = true);
  end;

implementation

{ TClassParams }

constructor TClassParams.Create(const p_Class : TInterfacedClass;
                             p_Args  : array of TValue;
                             p_Sigleton : boolean = false;
                             p_LazyLoad : boolean = true);
begin
  FInterfacedClass := p_Class;
  var pomLength := Length(p_Args);
  SetLength(FArgs, pomLength);
  for var i := 0 to pomLength - 1 do
    FArgs[i] := p_Args[i]; 
  FSigleton := p_Sigleton;
  FLazyLoad := p_LazyLoad;
end;

end.
