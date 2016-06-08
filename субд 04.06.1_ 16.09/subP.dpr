program subP;

uses
  Forms,
  sybU in 'sybU.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Lib-Client';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
