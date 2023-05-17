unit InterfaceVCLKernel;

interface

uses
  InterfaceKernel, Winapi.Windows, VCL.Forms;

type
  TFrameClass = class of TFrame;

  IVCLKernel = interface (IMainKernel)
    procedure Open(p_MainFrame : TFrameClass; p_FrameTitle : string);
  end;

implementation

end.
