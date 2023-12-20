program VisualKernel;

uses
  Vcl.Forms,
  System.SysUtils,
  BaseKernel in 'src\BaseKernel.pas',
  Kernel in 'src\Kernel.pas',
  MainFrame in 'MainFrame.pas' {frmMain: TFrame},
  VCLKernel in 'src\VCL\VCLKernel.pas',
  WindowSkeleton in 'src\VCL\WindowSkeleton.pas' {WndSkeleton},
  InterfaceBasePanel in 'src\VCL\Interfaces\InterfaceBasePanel.pas',
  InterfaceVCLKernel in 'src\VCL\Interfaces\InterfaceVCLKernel.pas',
  InterfaceKernel in 'src\Interfaces\InterfaceKernel.pas',
  InterfaceModule in 'src\Interfaces\InterfaceModule.pas',
  Module in 'src\Base classes\Module.pas',
  ClassParams in 'src\Base classes\ClassParams.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  MainKernel := TVCLKernel.Create(nil);
  if Supports(MainKernel, IVCLKernel) then
  begin
    (MainKernel as IVCLKernel).Open(TfrmMain, 'Okno g³ówne');
    MainKernel.Close;
  end;
end.
