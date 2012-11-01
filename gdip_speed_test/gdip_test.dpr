program gdip_test;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmTest},
  GDIPOBJ in 'GDIP\GDIPOBJ.pas',
  GDIPAPI in 'GDIP\GDIPAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTest, frmTest);
  Application.Run;
end.
