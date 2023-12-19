unit ClassParams;

interface

type
  TClassParams = record
    FSigleton : boolean;
    FInterfacedClass : TInterfacedClass;
    FLazyLoad : boolean;

    constructor Create(const p_Class : TInterfacedClass;
                             p_Sigleton : boolean = false;
                             p_LazyLoad : boolean = true);
  end;

implementation

{ TClassParams }

constructor TClassParams.Create(const p_Class: TInterfacedClass; p_Sigleton,
  p_LazyLoad: boolean);
begin
  FInterfacedClass := p_Class;
  FSigleton := p_Sigleton;
  FLazyLoad := p_LazyLoad;
end;

end.
