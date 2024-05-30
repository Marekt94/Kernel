unit BaseKernel;

interface

uses
  InterfaceKernel, InterfaceModule, System.Generics.Collections;

type
  TContainer = class (TInterfacedObject, IContainer)
  strict private
    FBaseKernel : IContainer;
  public
    procedure RegisterModules (p_ModuleList : TList<IModule>); virtual;
    procedure SetContainer (p_Container: IContainer);
    function GetVersion : Double;
  end;

implementation

{ TContainer }

function TContainer.GetVersion: Double;
begin
  Result := 0.0;
end;

procedure TContainer.RegisterModules(p_ModuleList: TList<IModule>);
begin
  if Assigned (FBaseKernel) then
    FBaseKernel.RegisterModules (p_ModuleList);
end;

procedure TContainer.SetContainer(p_Container: IContainer);
begin
  FBaseKernel := p_Container;
end;

end.
