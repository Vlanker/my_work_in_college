unit sybU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, Grids, DBGrids, ExtCtrls, DBCtrls, Menus,ShellAPI,//для апи
  StdCtrls, ADODB, ComCtrls, ToolWin, ScktComp, XPMan;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    qy1: TADOQuery;
    ADOConnection1: TADOConnection;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    N8: TMenuItem;
    N2: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Button3: TButton;
    Panel2: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Panel3: TPanel;
    Label6: TLabel;
    Edit6: TEdit;
    Button4: TButton;
    N12: TMenuItem;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    P1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ENS: TEdit;
    Button1: TButton;
    ts: TComboBox;
    Button2: TButton;
    Panel5: TPanel;
    Button5: TButton;
    Memo1: TMemo;
    X: TButton;
    Panel6: TPanel;
    ComboBox2: TComboBox;
    Button9: TButton;
    Button10: TButton;
    Label7: TLabel;
    StatusBar1: TStatusBar;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    N13: TMenuItem;
    N14: TMenuItem;
    List: TListBox;
    Button11: TButton;
    CSock: TClientSocket;
    Timer1: TTimer;
    N15: TMenuItem;
    pmTreyMenu: TPopupMenu;
    N16: TMenuItem;
    N17: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N18: TMenuItem;
    XPManifest1: TXPManifest;
    //для работы с треем
    Procedure ControlWindow(Var Msg:TMessage); message WM_SYSCOMMAND;
    Procedure IconMouse(var Msg:TMessage); message WM_USER+1;
    Procedure  Ic(n:Integer;Icon:TIcon);
    Procedure OnMinimizeProc(Sender:TObject);
    //=======================================
    procedure N5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Button5Click(Sender: TObject);
    procedure XClick(Sender: TObject);
    procedure Panel5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure ListExit(Sender: TObject);
    procedure ListClick(Sender: TObject);
    procedure CSockConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSockRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure CSockError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure N18Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  //да перемещения ока "руч. ввода"
  but:Boolean;
  vx,vy:integer;
  //имя таблицы
  TAbleName:string;

  //для авторизации
   vUserName:String;
   vPassword:String;
    vDBPath:String;
implementation

uses StrUtils;

{$R *.dfm}
//==трей================================
procedure TForm1.IconMouse(var Msg:TMessage);
Var p:tpoint;
begin
 GetCursorPos(p); // Запоминаем координаты курсора мыши
 Case Msg.LParam OF  // Проверяем какая кнопка была нажата
  WM_LBUTTONUP,WM_LBUTTONDBLCLK: {Действия, выполняемый по одинарному или двойному щелчку левой кнопки мыши на значке. В нашем случае это просто активация приложения}
                   Begin
                    Ic(2,Application.Icon);  // Удаляем значок из трея
                    ShowWindow(Application.Handle,SW_SHOW); // Восстанавливаем кнопку программы
                    ShowWindow(Handle,SW_SHOW); // Восстанавливаем окно программы
                    Update;
                   End;
  WM_RBUTTONUP: {Действия, выполняемый по одинарному щелчку правой кнопки мыши}
   Begin
    SetForegroundWindow(Handle);  // Восстанавливаем программу в качестве переднего окна
    pmTreyMenu.Popup(p.X,p.Y);  // Заставляем всплыть наше PopMenu
    PostMessage(Handle,WM_NULL,0,0);
   end;
 End;
end;
//при свораивании окна
Procedure TForm1.OnMinimizeProc(Sender:TObject);
Begin
 PostMessage(Handle,WM_SYSCOMMAND,SC_MINIMIZE,0);
End;
//когда свернули
Procedure TForm1.ControlWindow(Var Msg:TMessage);
Begin
 IF Msg.WParam=SC_MINIMIZE then
  Begin
   Ic(1,Application.Icon);                    // Добавляем значок в трей
   ShowWindow(Handle,SW_HIDE);                // Скрываем программу
   ShowWindow(Application.Handle,SW_HIDE);  // Скрываем кнопку с TaskBar'а
 End
 else inherited;
End;
Procedure TForm1.Ic(n:Integer;Icon:TIcon);
Var Nim:TNotifyIconData;
begin
 With Nim do
  Begin
   cbSize:=SizeOf(Nim);
   Wnd:=Self.Handle;
   uID:=1;
   uFlags:=NIF_ICON or NIF_MESSAGE or NIF_TIP;
   hicon:=Icon.Handle;
   uCallbackMessage:=wm_user+1;
   szTip :='Библиотека (Lib-Client)';
  End;
 Case n OF
  1: Shell_NotifyIcon(Nim_Add,@Nim);
  2: Shell_NotifyIcon(Nim_Delete,@Nim);
  3: Shell_NotifyIcon(Nim_Modify,@Nim);
 End;
end;

//=====================================

//= Расшифровка пакета ==================================================
function fUnCodeBin(vBin:string;vKey:String):String;
 var vUnBin:String;vPos:Integer;vByte:integer;
begin
vUnBin:='';
 for vPos:=1 to length(vBin) do begin
  if (vPos mod 2)=0 then
   vByte:=ord(vBin[vPos])+ord(vKey[(vPos mod length(vKey))+1])
  else
   vByte:=ord(vBin[vPos])-ord(vKey[(vPos mod length(vKey))+1]);
  if vByte<0 then vByte:=vByte+256;
  if vByte>255 then vByte:=vByte-256;
   vUnBin:=vUnBin+chr(vByte);
 end;
 fUnCodeBin:=vUnBin;
end;//===================================================================
//= Защифровка пакета ===================================================
function fCodeBin(vBin:string;vKey:String):String;
 var vUnBin:String;vPos:Integer;vByte:integer;
begin
vUnBin:='';
 for vPos:=1 to length(vBin) do begin
  if (vPos mod 2)=0 then
   vByte:=ord(vBin[vPos])-ord(vKey[(vPos mod length(vKey))+1])
  else
   vByte:=ord(vBin[vPos])+ord(vKey[(vPos mod length(vKey))+1]);
  if vByte<0 then vByte:=vByte+256;
  if vByte>255 then vByte:=vByte-256;
   vUnBin:=vUnBin+chr(vByte);
 end;
 fCodeBin:=vUnBin;
end;
//===================================================================

procedure ReST;
var I:Integer;
begin
form1.ComboBox1.Clear;
form1.ComboBox2.Clear;
for i := 0 to form1.DataSource1.DataSet.FieldCount-1  do
  begin   if i<>0 then
     form1.DataSource1.DataSet.Fields.Fields[i].DisplayWidth := 14 //ширина столбца
    else form1.DataSource1.DataSet.Fields.Fields[i].DisplayWidth := 2 ;;//ширина столбца
   form1.ComboBox1.Items.Add(form1.qy1.Fields[i].FieldName);
   form1.ComboBox2.Items.Add(form1.qy1.Fields[i].FieldName);
  end;
end;

procedure ReSizeTable;
var I:Integer;
begin
form1.ComboBox1.Clear;
form1.ComboBox2.Clear;
form1.List.Clear;
 for i := 0 to form1.DataSource1.DataSet.FieldCount-1  do
  begin
    if i<>0 then
     form1.DataSource1.DataSet.Fields.Fields[i].DisplayWidth := 14 //ширина столбца
    else form1.DataSource1.DataSet.Fields.Fields[i].DisplayWidth := 2 ;
    form1.ComboBox1.Items.Add(form1.qy1.Fields[i].FieldName);
    form1.ComboBox2.Items.Add(form1.qy1.Fields[i].FieldName);
    form1.List.Items.Add(form1.qy1.Fields[i].FieldName);
   end;
form1.ComboBox1.ItemIndex := -1;
form1.ComboBox2.ItemIndex := -1;
form1.List.ItemIndex := -1;
end;

procedure SendTextToServer(vStr:String);
 var vData:String;
begin
 if form1.CSock.Active then begin
 vData:=fCodeBin(vStr,'000#code#local'); //шифруем данные
  form1.CSock.Socket.SendText(vData); //отсылаем шифровку
 end;
end;

procedure pRunSQL(vCode:string);
begin
 SendTextToServer('0008'+vCode);//посылаем серверу запрос
end;

procedure pRunClient(vDataCode:String);  //Общение с сервером по сокету
var vUserCode:Integer;vQuerText:String;
begin
 vUserCode:=StrToInt(LeftStr(vDataCode,4)); //Считываем код
 vQuerText:=RightStr(vDataCode,Length(vDataCode)-4); //Считываем данные
  case vUserCode of
  7000: begin //Сервер дал маршрутизацию
   vDBPath:=vQuerText;
   form1.ADOConnection1.Connected:=False;
   form1.ADOConnection1.ConnectionString:=vQuerText;
   form1.ADOConnection1.Connected:=True;
   form1.DBGrid1.DataSource.Enabled:=True;
   form1.qy1.Active:=false;
   form1.qy1.SQL.Clear;
   form1.qy1.SQL.Add('Select * From '+TableName);
   form1.qy1.Active:=true;
   ReSizeTable;
   form1.StatusBar1.Panels[5].Text:='маршрут получен';
   form1.StatusBar1.Panels[5].Text:='база доступна';
  end;
  7024: begin //Сервер пропустил запрос и успешно выполнил его
         form1.qy1.Active:=false;
         form1.qy1.SQL.Clear;
         form1.qy1.SQL.Add('select * from '+TableName);
         form1.qy1.ExecSQL;
         form1.qy1.Active:=true;
         form1.Button6.Click;
         form1.DBGrid1.Refresh;
         form1.StatusBar1.Panels[3].Text:='запрос прошёл и успешно выполнен';
        end;
   0014: SendTextToServer('0015'); //подверждение активности
   0042: begin ShowMessage('Администратор разорвал соединение');
               form1.close;
         end;
   8000:begin
     form1.StatusBar1.panels[1].Text:='Сервер не подтвердил авторизацию!';
     ShowMessage(form1.StatusBar1.panels[1].Text);
     form1.StatusBar1.Panels[5].Text:='нет доступа к базе';
    end;
   8001: begin
     form1.StatusBar1.panels[1].Text:='Высланная учётная запись уже занята';
     ShowMessage(form1.StatusBar1.panels[1].Text);
     form1.StatusBar1.Panels[5].Text:='нет доступа к базе';
    end;
   8002:begin
     form1.StatusBar1.panels[1].Text:='Высланная учётная запись пуста!';
     ShowMessage(form1.StatusBar1.panels[1].Text);
     form1.StatusBar1.Panels[5].Text:='нет доступа к базе';
    end;
   8023:begin

     form1.StatusBar1.panels[3].Text:='В запросе обнаружены синтаксические ошибки!';
     ShowMessage(form1.StatusBar1.panels[3].Text);
    end;
   8024:begin

     form1.StatusBar1.panels[1].Text:='На выполнение запроса нет прав, пройдите авторизацию!';
     ShowMessage(form1.StatusBar1.panels[1].Text);
          form1.StatusBar1.Panels[5].Text:='нет доступа к базе';
    end;
  else
    //Теоретически, выполнение данной строчки не возможно
   form1.StatusBar1.panels[1].Text:='Сервер сбоит';
   ShowMessage(form1.StatusBar1.panels[3].Text);
  end;
end;

procedure loadSettings(FileName:string);//Подгрузка конфигураций сокета
 var vF:TextFile;vT:String;
begin
 AssignFile(vF,FileName);
  ReSet(vF);
 repeat
  Readln(vF,vT);
   if LeftStr(vT,5)='port=' then form1.CSock.Port:=strtoint(RightStr(vT,length(vT)-5));  //Порт
   if LeftStr(vT,7)='server=' then form1.CSock.Host:=RightStr(vT,length(vT)-7);   //IP
   if LeftStr(vT,5)='name=' then form1.Caption:=RightStr(vT,length(vT)-5);//имя программы
   if LeftStr(vT,6)='table=' then TableName:=RightStr(vT,length(vT)-6);   //имя таблицы
 until Eof(vF);
 CloseFile(vF);
end;

{==== подгонк размера таблицы под панельку(конструктор,добавить,удалить)и
 при закрытии панельки====}
function PnWIL(IPan:Byte):Byte;
begin
if IPan=0 then
 begin
  form1.Panel1.Visible:=false;
  form1.P1.Visible:=false;
  form1.Panel6.Visible:=false;
  form1.DBGrid1.Left:= 0;
 end;
if IPan=1 then
 begin
  form1.p1.Visible :=true;
  form1.DBGrid1.Left:=form1.P1.Width;
  form1.panel1.Visible :=false;
  form1.panel6.Visible :=false;
 end;
if IPan=2 then
 begin
  form1.Panel1.Visible :=true;
  form1.DBGrid1.Left:=form1.Panel1.Width;
  form1.p1.Visible :=false;
  form1.panel6.Visible :=false;
 end;
if IPan=3 then
 begin
  form1.Panel6.Visible :=true;
  form1.DBGrid1.Left:=form1.Panel6.Width;
  form1.panel1.Visible :=false;
  form1.p1.Visible :=false;
 end;
form1.DBGrid1.Width:=form1.width-form1.DBGrid1.left-6;
IPan:=0;
form1.StatusBar1.Panels[1].Text:='отсутствуют';
form1.StatusBar1.Panels[3].Text:='ождание';
end;

//добавление поля
procedure TForm1.N5Click(Sender: TObject);
begin
PnWIL(1);

end;

//закрытие конструктора
procedure TForm1.Button1Click(Sender: TObject);
begin
 PnWIL(0);
end;

 //проц. добавления столбца
procedure TForm1.Button2Click(Sender: TObject);
 var BdType:string;
begin
//в случае пустого  значения
if (ENS.Text ='') or (ts.Text ='') then
 begin
  StatusBar1.Panels[1].Text:='Введите название столбца!';
  ShowMessage(StatusBar1.Panels[1].Text);
 end
else
//типы данных
case ts.ItemIndex of
 0: BdType:='string';
 1: BdType:='integer';
 2: BdType:='datetime';
else
 BdType:='string';
end;
//запрос на добавление поля
 pRunSQL('ALTER TABLE '+TableName+' ADD '+ENS.Text+' '+BdType );
end;

//конструктор
procedure TForm1.N10Click(Sender: TObject);
begin
PnWIL(2);
end;

//выбор поля и поиска по нему
procedure TForm1.ComboBox1Change(Sender: TObject);
var
A:TFieldType;
begin
A :=  qy1.Fields[ComboBox1.ItemIndex].DataType;
case A of
//string
ftWideString:
 Begin
  panel2.Visible:= false;
  panel3.Visible:= True;
  panel4.Visible:= false;
 end;
//date
ftDateTime:
 Begin
  panel2.Visible:= false;
  panel3.Visible:= False;
  panel4.Visible:= True;
 end;
//int
ftInteger:
 Begin
  panel2.Visible:= True;
  panel3.Visible:= false;
  panel4.Visible:= False ;
 end;
end;
end;

//иниц.формы
procedure TForm1.FormCreate(Sender: TObject);
begin
try
vUserName:=InputBox('Авторизация','Введите логин','');
vPassword:=InputBox('Авторизация','Введите пароль','');
loadSettings('settings.ini'); // Подгрузка конфигураций сокета
CSock.Close;
CSock.Open; // открываем соединение
memo1.Lines.Add('Select * From '+TableName);
timer1.Enabled:=true;
ReSizeTable;
except
 ShowMessage('Подключение к серверу не было установленно');
 form1.StatusBar1.Panels[5].Text:='Подключение к серверу не было установленно!';
end;

end;

// p1
procedure TForm1.Button4Click(Sender: TObject);
begin
PnWIL(0);
end;

//поиск
procedure TForm1.Button3Click(Sender: TObject);
var
  i : integer;
begin
  qy1 .Active := false;
//строка
if Panel3.Visible then  begin
  qy1.SQL.Strings[1] :='Where '+ComboBox1.Text +' Like "%'+Edit6.Text+'%"';
  end;
//дата
if Panel4.Visible then
  qy1.SQL.Strings[1] := 'Where [' +ComboBox1.Text + '] between '+DateToStr(DateTimePicker1.Date)+' And '+DateToStr(DateTimePicker1.Date);
//число
if Panel2.Visible then
 if RadioButton1.Checked then
  qy1.SQL.Strings[1] := 'Where [' +ComboBox1.Text+ '] Like ' +  Edit1.Text;
//диапозон
 if RadioButton2.Checked then
   qy1.SQL.Strings[1] := 'Where [' +ComboBox1.Text + '] between '+Edit2.Text+' And '+Edit3.Text;
qy1.Active := true;
  for i := 0 to DataSource1.DataSet.FieldCount-1  do
    DataSource1.DataSet.Fields.Fields[i].DisplayWidth := 14;
end;

//обновление
procedure TForm1.N12Click(Sender: TObject);
begin
  Button6.Click;
end;

//выбор для числового значения
{одиночное----}
procedure TForm1.RadioButton1Click(Sender: TObject);
begin
if RadioButton1.Checked then
  begin
    GroupBox1.Enabled := False ;
    GroupBox2.Enabled := True ;
  end;
end;
{диапозон----}
procedure TForm1.RadioButton2Click(Sender: TObject);
begin
if RadioButton2.Checked then
  begin
   GroupBox1.Enabled := True;
   GroupBox2.Enabled := false;
  end;
end;

{нажатие кнопки с Enter------------}
procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then Button3.Click
end;
procedure TForm1.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then Button3.Click
end;
procedure TForm1.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then Button3.Click
end;

//выполнение ручного запроса
procedure TForm1.Button5Click(Sender: TObject);
begin
 pRunSQL(Memo1.Text);
end;

//панель поиска
procedure TForm1.N11Click(Sender: TObject);
begin
panel5.Visible :=true;
end;
procedure TForm1.XClick(Sender: TObject);
begin
panel5.Visible :=false;
//очиска поля ручного ввода
memo1.Clear;
//стандартная форма запроса
Memo1.Lines.Add('Select * From '+TableName);
 form1.StatusBar1.Panels[1].Text:='нет';
end;

//передвижение окна "ручного ввода"
procedure TForm1.Panel5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
vx:= x;//запоминаем координаты окошка
vy:= y ;
but := true;
end;
procedure TForm1.Panel5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var tx,ty:integer;
begin
if but = true then
  begin
    tx := Panel5.left + x -vx ;//координаты х
    ty := Panel5.top + y  - vy;//координаты у
     if tx<0 then tx:=0;
     if ty<0then ty:=0;
     if tx>width-Panel5.Width-8 then tx:=width-Panel5.Width-8;
     if ty>height-Panel5.Height-73 then ty:=height-Panel5.Height-73;

  Panel5.Left:=tx;Panel5.Top:=ty;
  end;
end;
procedure TForm1.Panel5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 but := False;
end;
{==========================}
//обновить данные с сервера
procedure TForm1.Button6Click(Sender: TObject);
begin
 qy1.Active:=false;
 qy1.SQL.Clear;
 qy1.SQL.Add('select * from '+TableName);
 qy1.ExecSQL;
 qy1.Active:=true;
// form1.DBGrid1.Refresh;
 ReSizeTable;//подгонка размеров  в таблице и списка столбцов
end;
//вставка записи
procedure TForm1.Button7Click(Sender: TObject);
begin
pRunSQL('iNSERT INTO ['+TAbleName+'] default values');
end;
//удаление записи
procedure TForm1.Button8Click(Sender: TObject);
 var vN:String;
begin
 vN:=qy1.Fields[0].Value;
 pRunSQL('delete from '+TableName+' where id='+vN);
end;

procedure TForm1.N6Click(Sender: TObject);
begin
PnWIL(3);
end;
procedure TForm1.Button9Click(Sender: TObject);
begin
 PnWIL(0);
end;
// удаление  столбца
procedure TForm1.Button10Click(Sender: TObject);
begin//
if ComboBox2.Text ='' then
 begin
   ShowMessage('Выберите столбец!!!');
   StatusBar1.Panels[1].Text:='Выберите столбец!!!'
 end
else //формирование запроса
  pRunSQL('alter table '+TableName+' drop ['+combobox2.Text+']' );
end;

procedure TForm1.N14Click(Sender: TObject);
begin
Ic(2,Application.Icon);//!!
close;
end;

procedure TForm1.N7Click(Sender: TObject);
begin //список столб.вкл\выкл
List.Visible:=not List.Visible;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin //список столб.вкл\выкл
List.Visible:=not List.Visible;
end;

procedure TForm1.ListExit(Sender: TObject);
begin //список столб.откл
List.Visible:=false;
end;

procedure TForm1.ListClick(Sender: TObject);
var i:integer;
 vSQ:String;
begin
qy1.Active:=false;//откл Sql
qy1.SQL.Clear;//отчиска
{Формирование запроса}
vSQ:='select ';//выбрать следующие поля
for i :=0 to list.Items.Count-1 do
 if list.Selected[i] then vsQ:=vsQ+'['+TableName+'].['+list.Items[i]+'], ';
vsQ:=LeftStr(vSQ,length(vSQ)-2)+' From '+TableName;//удаление пследних 2 символов
qy1.SQL.Add(vsQ);//посылка запроса на исполнитель
qy1.Active:=true;//активация Sql
ReST;//подгонка размера и списка для "выборки"
end;

procedure TForm1.CSockConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
//запись в строку состояния Ip-сервера
statusbar1.Panels.Items[5].Text:='Соединён. Ip-cерверa('+socket.LocalAddress+')';
end;
//чтение присланных сообщений от сервера
procedure TForm1.CSockRead(Sender: TObject; Socket: TCustomWinSocket);
 var vData:String;
begin
 vData:=Socket.ReceiveText;//резервируем место под сообщение
 vData:=fUnCodeBin(vData,'000#code#local'); //дешифруем
 pRunClient(vData); //посылаем
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 SendTextToServer('4004'); //Разрыв
end;
//для повторной авторизации
procedure TForm1.Timer1Timer(Sender: TObject);
begin
try                    //попробовать отослать имя и пароль и выкл таймер
 SendTextToServer('0000'+vUserName+';'+vPassword);
 Timer1.Enabled:=false;
except       //в случае ошибки
 ShowMessage('Ошибка соединения');
 form1.StatusBar1.Panels[5].Text:='Ошибка соединения!';
end;
end;
//повторная авторизация
procedure TForm1.N15Click(Sender: TObject);
begin
//востанавливаем строку состояния
form1.StatusBar1.Panels[1].Text:='нет';
form1.StatusBar1.Panels[3].Text:='ожидание';
form1.StatusBar1.Panels[5].Text:='ожидание авторизации';
//==
SendTextToServer('4004'); //Разрыв
form1.DBGrid1.DataSource.Enabled:=false;//разравает ресурсы базы
form1.qy1.Active:=false;//вык sql
form1.ADOConnection1.Connected:=False;//отк сод с базой
vUserName:=InputBox('Авторизация','Введите логин','');
vPassword:=InputBox('Авторизация','Введите пароль','');
Timer1.Enabled:=True;//запускаем таймер авторизации
end;
//ошибки с сокетом
procedure TForm1.CSockError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  case ErrorCode of
   10061:begin
     ShowMessage('Сервер не доступен!');
     form1.StatusBar1.Panels[5].Text:='Сервер не доступен!';
     ErrorCode:=0;//сбрасывает ошибку в о, чтоб она не высветилась
    end;
    10060: begin
            form1.StatusBar1.Panels[5].Text:='Отсутствует соединение!';
            ErrorCode:=0;
           end;
  end;
end;

procedure TForm1.N18Click(Sender: TObject);
begin
N15.Click;
end;

procedure TForm1.N16Click(Sender: TObject);
begin
Button6.Click;
end;

procedure TForm1.N20Click(Sender: TObject);
begin
N14.Click
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
ShowMessage('Програмный модуль "'+ form1.Caption+'". Описание программы представленно в "Руководстве пользователя"');
end;

end.
