program FMXSkiaBrowser;

uses
  {$IFDEF DELPHI17_UP}
  System.StartUpCopy,
  {$ENDIF }
  FMX.Forms,
  FMX.Types,
  FMX.Skia,     // This unit comes from the Skia4Delphi project
  uCEFApplication,
  uCEFFMXWorkScheduler,
  uMainForm in 'uMainForm.pas' {MainForm},
  uFMXApplicationService in 'uFMXApplicationService.pas';

{$R *.res}

const
  IMAGE_FILE_LARGE_ADDRESS_AWARE = $0020;

// CEF needs to set the LARGEADDRESSAWARE ($20) flag which allows 32-bit processes to use up to 3GB of RAM.
{$IFDEF WIN32}{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}{$ENDIF}

begin
  // Enable Skia usage. 
  GlobalUseMetal := True;
  GlobalUseSkiaRasterWhenAvailable := False;
  GlobalUseSkia := True;
  // GlobalCEFApp creation and initialization moved to a different unit to fix the memory leak described in the bug #89
  // https://github.com/salvadordf/CEF4Delphi/issues/89
  CreateGlobalCEFApp;

  if GlobalCEFApp.StartMainProcess then
    begin
      Application.Initialize;
      Application.CreateForm(TMainForm, MainForm);
      Application.Run;

      // The form needs to be destroyed *BEFORE* stopping the scheduler.
      MainForm.Free;

      GlobalFMXWorkScheduler.StopScheduler;
    end;

  DestroyGlobalCEFApp;
  DestroyGlobalFMXWorkScheduler;
end.
