program MyMovie;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  sevenzip in 'sevenzip.pas',
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas',
  OpensubtitlesAPI in 'OpensubtitlesAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
