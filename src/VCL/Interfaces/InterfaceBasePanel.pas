unit InterfaceBasePanel;

interface

type
  IBasePanel = interface
    ['{B30E985E-AC72-4D16-841F-0C4C247DCD26}']
    procedure Clean;
    function Unpack (const p_Object : TObject) : boolean;
    function Pack   (var   p_Object : TObject) : boolean;
  end;

  IBasePanelValidator = interface
    ['{3FE85D62-7882-420A-8930-E43D13DC9DB3}']
    function Check: boolean;
  end;

implementation

end.
