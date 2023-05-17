program KernelProj;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  BaseKernel in 'src\BaseKernel.pas',
  InterfaceKernel in 'src\InterfaceKernel.pas',
  InterfaceModule in 'src\InterfaceModule.pas',
  Kernel in 'src\Kernel.pas',
  InterfaceBasePanel in 'src\InterfaceBasePanel.pas';

{$R *.res}

var
  VCLKernel : IMainKernel;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Run;
  VCLKernel := TKernel.Create(nil);
  VCLKernel.Open;//(TfrmMain, 'G³ówne okno');
  VCLKernel.Close;
end.
