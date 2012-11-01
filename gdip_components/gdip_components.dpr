program gdip_components;

uses
  Forms,
  mainform in 'mainform.pas' {Form1},
  GDIPOBJ in '..\gdip\GDIPOBJ.pas',
  DirectDraw in '..\gdip\DirectDraw.pas',
  GDIPAPI in '..\gdip\GDIPAPI.pas',
  ClockComponent in 'ClockComponent.pas',
  GDIPComponents in 'GDIPComponents.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
