program NoVisualKernel;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  BaseKernel in 'src\BaseKernel.pas',
  Kernel in 'src\Kernel.pas',
  InterfaceKernel in 'src\Interfaces\InterfaceKernel.pas',
  InterfaceModule in 'src\Interfaces\InterfaceModule.pas',
  Module in 'src\Base classes\Module.pas',
  ClassParams in 'src\Base classes\ClassParams.pas';

begin
  try
    ReportMemoryLeaksOnShutdown := true;
    MainKernel := TKernel.Create(nil);
    MainKernel.Open;
    MainKernel.Close;
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
