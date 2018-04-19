program maze;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {uMain},
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TuMain, uMain);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
