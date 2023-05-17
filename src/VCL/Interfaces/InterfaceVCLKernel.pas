unit InterfaceVCLKernel;

interface

uses
  InterfaceKernel, Winapi.Windows, VCL.Forms;

type
  TFrameClass = class of TFrame;

  IVCLKernel = interface (IMainKernel)
  ['{AD911BB7-63D2-4C8C-873F-14D1719D504B}']
    procedure Open(p_MainFrame : TFrameClass; p_FrameTitle : string);
  end;

implementation

end.
