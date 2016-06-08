program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainFRM};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Server';
  Application.CreateForm(TMainFRM, MainFRM);
  Application.Run;
end.
