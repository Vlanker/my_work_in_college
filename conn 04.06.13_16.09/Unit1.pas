unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Sockets, DB, ADODB, ExtCtrls, DBCtrls, Grids, DBGrids,
  ScktComp, Outline, XPMan, ComCtrls, ShellAPI, Buttons;

type
  TMainFRM = class(TForm)
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    ServerSocket: TServerSocket;
    tPing: TTimer;
    tTimeOut: TTimer;
    XPManifest1: TXPManifest;
    ctrPage: TPageControl;
    ctPage1: TTabSheet;
    ctPage2: TTabSheet;
    lblState: TLabel;
    txtLog: TMemo;
    btnClear: TButton;
    btnOpen: TButton;
    gbServer: TGroupBox;
    btnLoad: TButton;
    btnUnload: TButton;
    Label3: TLabel;
    txtSQL: TMemo;
    btnRunSQL: TButton;
    gbConnects: TGroupBox;
    usrList: TOutline;
    btnRefresh: TButton;
    btnKick: TSpeedButton;
    procedure btnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure btnUnloadClick(Sender: TObject);
    procedure tPingTimer(Sender: TObject);
    procedure tTimeOutTimer(Sender: TObject);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure btnClearClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnKickClick(Sender: TObject);
    procedure btnRunSQLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Type
     UsrLst=Record
      uLogin:String;
      uPassword:String;
      uIP:String;
      uRang:Byte;
      uAccess:Boolean;
     End;

var
  MainFRM: TMainFRM;
   vDBPath:String;
    vUserList:Array[0..256] of UsrLst;
    vUserCount:Integer;
    vCurrentUserPing:Integer;
implementation

uses StrUtils;

{$R *.dfm}

procedure pPutLogInfo(Text:string;txtInfo:String);
 var vF:TextFile;vT:String;vB:String;vR:String;
begin
vT:='log\'+datetostr(Date)+'_server.log';
 if FileExists(vT) then begin
  if Text<>'' then begin
   AssignFile(vF,vT);
   ReSet(vF);
    repeat
     readln(vF,vR);
      vB:=vB+vR+#13+#10;
    until Eof(vF);
   CloseFile(vF);
  end
  else begin
   DeleteFile(vT);
   mainfrm.txtLog.Text:='';
    exit;
  end;
 end;
 Text:='['+DateToStr(Date)+'-'+TimeToStr(Time)+']: '+Text;
 if txtInfo<>'' then Text:=Text+#13+#10+'   //[Info: '+#13+#10+txtInfo+#13+#10+']//';
vB:=vB+Text;
 AssignFile(vF,vT);
 ReWrite(vF);
  Writeln(vF,vB);
 CloseFile(vF);
mainfrm.txtLog.Lines.LoadFromFile(vT);
end;

procedure pShowAccesList;
var i:integer;vT:String;vseli:integer;
begin
vseli:=mainfrm.usrList.SelectedItem;
mainfrm.usrList.Lines.Text:='';
 for i:=0 to vUserCount do begin
  mainfrm.usrList.Lines.Add('.. Логин: <.'+vUserList[i].uLogin+'.>');
   if vUserList[i].uAccess then begin
    mainfrm.usrList.Lines.Add(' Статус: <Соединён>'+vT);
    mainfrm.usrList.Lines.Add('  [Доступ] = 1;');
    mainfrm.usrList.Lines.Add('  [Ранг] = '+inttostr(vUserList[i].uRang)+';');
    mainfrm.usrList.Lines.Add(' Адрес:');
    mainfrm.usrList.Lines.Add('  [IP] = |'+vUserList[i].uIP+'|;');
    mainfrm.usrList.Lines.Add('  [Порт] = 101;');
   end
   else begin
    mainfrm.usrList.Lines.Add(' Статус: <Не в сети>'+vT);
    mainfrm.usrList.Lines.Add('  [Доступ] = 0;');
   end;
 end;
 for i:=1 to MainFRM.usrList.Lines.Count do //перебираем все элементы
  mainfrm.usrList.Items[i].FullExpand;  //раскрываем всё сетевое дерево
mainfrm.usrList.SelectedItem:=vSelI;
end;

//= Загрузка списка пользователей =======================================
procedure pInitUserList(filename:string);
 var vT:String;vF:TextFile;I:integer;
begin
 AssignFile(vF,filename);
 ReSet(vF);ReadLn(vF,vT);
 vUserCount:=-1;
   for I:=0 to strToInt(MidStr(vT,2,length(vT)-2))-1 do begin
    ReadLn(vF,vUserList[i].uLogin);
    ReadLn(vF,vUserList[i].uPassword);
    ReadLn(vF,vUserList[i].uRang);
     vUserList[i].uIP:='127.0.0.1:'+inttostr(i);
     inc(vUserCount);
   end;
 CloseFile(vF);
end;//===================================================================

//= Предоставление доступа пользователю =================================
function fAddUser(nAutoris:string;nIP:String):Integer;
 var i:integer;
begin
fAddUser:=0; //сбрасываем в функцию 0
 if nAutoris=';' then begin //если пользователь не указал авторизационные данные
   fAddUser:=3; //возвращаем код 3
  exit; //заканчиваем выполняь функцию
 end;
 for i:=0 to vUserCount do //Сканирование списка пользователей
  if (vUserList[i].uLogin+';'+vUserList[i].uPassword=nAutoris)then begin //Если пользователь прошёл авторизацию
   if not vUserList[i].uAccess then begin //Проверяем, получал ли доступ данный пользователь ранее
    vUserList[i].uIP:=nIP;vUserList[i].uAccess:=True; //Записываем IP подключаемого пользователя
    fAddUser:=1; //Система безопасности успешно внесла пользователя в реестр
   break; //Выход из сканера
   end //Граница проверки доступа
   else fAddUser:=2; //Пользователь был авторизирован ранее
  end;
end;//===================================================================

//= Функция чтения доступа пользователя ================================
function fGetUserAccess(nIP:String):Boolean; //В качестве аргумента IP адрес
 var i:integer; //Счётчик для сканера
begin
 for i:=0 to vUserCount do //Сканирование базы клиентов
  if vUserList[i].uIP=nIP then begin //Если клиент найден
   fGetUserAccess:=vUserList[i].uAccess; //Считываем его доступ в return
   break; //Выход из цикла
  end;  //Граница сканирования
end;//===================================================================

//= Функция чтения IP адреса пользователя ===============================
function fGetUserIP(nLogin:String):String; //В качестве аргумента логин
 var i:integer; //Счётчик для сканера
begin
 for i:=0 to vUserCount do //Сканирование базы клиентов
  if vUserList[i].uLogin=nLogin then begin //Если клиент найден
   fGetUserIP:=vUserList[i].uIP; //Считываем его адрес
   break; //Выход из цикла
  end;  //Граница сканирования
end;//===================================================================

//= Функция чтения Логина пользователя ==================================
function fGetUserName(nIP:String):String; //В качестве аргумента логин
 var i:integer; //Счётчик для сканера
begin
 for i:=0 to vUserCount do //Сканирование базы клиентов
  if vUserList[i].uIP=nIP then begin //Если клиент найден
   fGetUserName:=vUserList[i].uLogin; //Считываем его адрес
   break; //Выход из цикла
  end;  //Граница сканирования
end;//===================================================================

//= Функция чтения Пароля адреса пользователя ===========================
function fGetUserPassword(nIP:String):String; //В качестве аргумента логин
 var i:integer; //Счётчик для сканера
begin
 for i:=0 to vUserCount do //Сканирование базы клиентов
  if vUserList[i].uIP=nIP then begin //Если клиент найден
   fGetUserPassword:=vUserList[i].uPassword; //Считываем его адрес
   break; //Выход из цикла
  end;  //Граница сканирования
end;//===================================================================

//= процедура разъединения пользователя =================================
procedure pSetUserDisconnect(nIP:String);
 var i:integer; //Счётчик для сканера
begin
 for i:=0 to vUserCount do //Сканирование базы клиентов
  if vUserList[i].uIP=nIP then begin //Если клиент найден
   vUserList[i].uAccess:=false; //очищаем доступ
   break; //Выход из цикла
  end;  //Граница сканирования
end;//===================================================================

//= Загрузка конфигураций маршрутизации =================================
procedure pLoadPath(filename:String);
 var vT:String;vF:TextFile; //Указатели на читаемый файл
begin
 AssignFile(vF,filename); //Линк указателя
 ReSet(vF); //Сброс курсора
  ReadLn(vF,vT); //Считывание маршрута
   vDBPath:=vT; //Расшифровка
 CloseFile(vF); //Закрытие файла и очистка указателя
end;//===================================================================

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
 end;  //
 fCodeBin:=vUnBin;
end;//===================================================================

//= Инициализация сервера ===============================================
function StartServer(vPort:Integer):Boolean;
begin
 MainFRM.ServerSocket.Close; //Закрываем соединение
 MainFRM.ServerSocket.Port:=vPort; //Устанавливаем внешний порт
 MainFRM.ServerSocket.Open; //Открываем порт
  StartServer:=MainFRM.ServerSocket.Active; //Возврат результата в функцию
end;//===================================================================

//= Ответы сервера ======================================================
procedure pSendData(vText:String;Client:string);
 var I:Integer; //Счётчик клиентов
begin
try
vText:=fCodeBin(vText,'000#code#local'); //шифр канала
 for i:=0 to mainfrm.ServerSocket.Socket.ActiveConnections-1 do //Сканируем всех клиентов
  if mainfrm.ServerSocket.Socket.Connections[i].RemoteAddress=Client then begin //Если наш клиент найден
    mainfrm.ServerSocket.Socket.Connections[i].SendText(vText); //Посылаем ему ответ
    break; //Выходим из цикла
   end; //Граница условия
except
 pPutLogInfo('Ошибка отправки ответа',Client);
end;
end;//===================================================================

//= Проверка активности пользователей ===================================
procedure TMainFRM.tPingTimer(Sender: TObject);
begin
 if vUserList[vCurrentUserPing].uAccess then begin //считываем доступ
  pSendData('0014',vUserList[vCurrentUserPing].uIP); // отсылаем пользователю данных
 tTimeOut.Enabled:=true; //переходим в режим ожидания
 tPing.Enabled:=false; //приостанавливаем пинг
 end;
end;//===================================================================

//= Интерпритация запроса клиента =======================================
procedure RunServer(vDataCode:String;ClientSocket:TCustomWinSocket);
var vUserCode:Integer;vQuerText:String;vErr:Integer;
begin
 try //игнорируем ошибки
 vUserCode:=StrToInt(LeftStr(vDataCode,4)); //Считываем код
 except
 vUserCode:=-1; //сбрасываем код действия
  pPutLogInfo('Подозрительный запрос',vDataCode); //записываем событие в журнал
 end;
 vQuerText:=RightStr(vDataCode,Length(vDataCode)-4); //Считываем данные
  Case vUserCode of  //Сканируем код
    0000: begin //Запрос авторизации
    pPutLogInfo('Запрос авторизации','Клиент '+ClientSocket.RemoteAddress); //записываем событие в журнал
      case fAddUser(vQuerText,ClientSocket.RemoteAddress) of //пытаемся добавить пользователя
       0: begin
       pShowAccesList; //обновляем список клиентов
        pSendData('8000',ClientSocket.RemoteAddress); //Сообщаем клиенту об ошибке авторизации
         pPutLogInfo('Отказ в доступе','Запрос клиента '+vQuerText); //записываем событие в журнал
       end;
       1: begin
       pShowAccesList; //обновляем список клиентов
        pSendData('7000'+vDBPath+';User ID='+fGetUserName(ClientSocket.RemoteAddress)+';Password='+fGetUserPassword(ClientSocket.RemoteAddress),ClientSocket.RemoteAddress); //Отправляем  клиенту маршрутизацию
         pPutLogInfo('Клиент авторизирован','Запрос клиента '+vQuerText); //записываем событие в журнал
       end;
       2: begin
       pShowAccesList; //обновляем список клиентов
        pSendData('8001',ClientSocket.RemoteAddress); //Сообщаем клиенту о том, что учётная запись занята
         pPutLogInfo('Учётная запись занята','Запрос клиента '+vQuerText); //записываем событие в журнал
       end;
       3: begin
       pShowAccesList; //обновляем список клиентов
        pSendData('8002',ClientSocket.RemoteAddress); //Сообщаем клиенту о том, что пользователь пошутил, серверу смешно
         pPutLogInfo('Клиент авторизирован','Запрос клиента '+vQuerText); //записываем событие в журнал
       end;
      end;
    end;
    0015: begin //если пользователь ответил
      inc (vCurrentUserPing); //Переходим к следующему пользователю
     mainfrm.tTimeOut.Enabled:=False; //Отключаем тайм -аут
     mainfrm.tPing.Enabled:=True; //продолжаем пинг, оставляя статус доступа пользователя
    end;
    4004: pSetUserDisconnect(ClientSocket.RemoteAddress); //Пользователь отключился
    0008: begin //Запрос выполнения SQL
     if fGetUserAccess(ClientSocket.RemoteAddress) then begin //Проверяем доступ клиента к базе
      try
        mainfrm.ADOQuery1.SQL.Text:=vQuerText; //записываем код запроса
        mainfrm.ADOQuery1.ExecSQL; //посылаем запрос не возвращающий значения
         Application.ProcessMessages; //работаем асинхронно
          sleep(100); //ждём пока запрос в обработке...
        pPutLogInfo('Обработан запрос',vQuerText); //записываем событие в журнал
       pSendData('7024',ClientSocket.RemoteAddress) // Отправляем клиенту сообщение об успешном выполнении запроса
      except
        pPutLogInfo('Попытка обработать запрос, ошибочная команда',vQuerText); //записываем событие в журнал
       pSendData('8023',ClientSocket.RemoteAddress); // Отправляем клиенту сообщение о ошибке выполнения запроса
      end;
      end
     else begin
       pPutLogInfo('Попытка обработать запрос, отказанно в доступе','|'+ClientSocket.LocalAddress+'| :: '+vQuerText);
      pSendData('8024',ClientSocket.RemoteAddress); //Отправляем клиенту ошибку доступа
     end;
    end;
  end;
end;//===================================================================

//= Получение данных от клиентов ========================================
procedure TMainFRM.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var vData:String; //Буффер данных
begin
vData:=Socket.ReceiveText; //Получаем пакеты в буффер
vData:=fUnCodeBin(vData,'000#code#local'); //Расшифровываем пакет
 RunServer(vData,Socket); //Работаем с клиентом
end;//===================================================================

procedure TMainFRM.btnLoadClick(Sender: TObject);
begin
btnUnload.Enabled:=true;btnLoad.Enabled:=false; //меняем графику для кнопок
 StartServer(101); //загружаем сервер
  caption:= ServerSocket.Socket.LocalHost + ' - Соккет открыт!'; //
  try
   ADOConnection1.ConnectionString:=vDBPath; //принемаем маршрутизатор
   ADOConnection1.Connected:=True; //выполняем соединение с SQL сервером
   tping.Enabled:=true; //включаем активный пинг
   pPutLogInfo('Подключение баз данных',''); //записываем событие в журнал
  Except
   pPutLogInfo('Базы данных не были подключены',vDBPath); //записываем событие в журнал
  end;
 pShowAccesList; //обновляем список клиентов
end;

procedure TMainFRM.FormCreate(Sender: TObject);
begin
vCurrentUserPing:=0; //Начинаем пинг с первого пользователя
 pInitUserList('UserList.txt'); //Загружаем список пользователей
 pLoadPath('Path.txt'); //Загружаем маршрутизатор
pPutLogInfo('Старт сервера',''); //записываем событие в журнал
end;

procedure TMainFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree; //при закрытии формы, выгружаем приложение из памяти
end;


procedure TMainFRM.btnUnloadClick(Sender: TObject);
begin
 close;
end;

procedure TMainFRM.tTimeOutTimer(Sender: TObject);
begin
 vUserList[vCurrentUserPing].uAccess:=False; //закрываем доступ пользователю
  pShowAccesList; //обновляем список клиентов
 inc (vCurrentUserPing); //переходим к следующему пользователю
 if vCurrentUserPing>vUserCount then vCurrentUserPing:=0; //если пользователи перебраны, начинаем с начала
  tTimeOut.Enabled:=False; //отключаем тайм-аут
  tPing.Enabled:=True; //включаем пинг
end;

procedure TMainFRM.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
pShowAccesList; //обновляем список клиентов
 pPutLogInfo('Ошибка сокета'+#13+#10+'err '+inttostr(ErrorCode)+'#','Клиент |'+Socket.LocalAddress+'|'); //записываем событие в журнал
end;

procedure TMainFRM.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
pShowAccesList; //обновляем список клиентов
 pPutLogInfo('Подключение клиента','Клиент |'+Socket.RemoteAddress+'|'); //записываем событие в журнал
end;

procedure TMainFRM.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
pShowAccesList; //обновляем список клиентов
 pPutLogInfo('Разъединение клиента','Клиент |'+Socket.RemoteAddress+'|'); //записываем событие в журнал
end;


procedure TMainFRM.btnClearClick(Sender: TObject);
begin
 pPutLogInfo('',''); //очистка логов
end;

procedure TMainFRM.btnOpenClick(Sender: TObject);
begin
 ShellExecute(Handle, 'open', 'log\', nil, nil, SW_SHOWNORMAL) //запуск проводника
end;

procedure TMainFRM.btnKickClick(Sender: TObject);
 var i:Integer;vUsr:String;
begin
 i:=usrlist.SelectedItem-1; //Запоминаем выбранную запись
  if LeftStr(usrList.Lines.Strings[i],2)<>'..' then begin //проверяем, не является ли она корнем
   repeat
    i:=i-1;//если не корень, сбрасываем один уровень
   until LeftStr(usrList.Lines.Strings[i],2)='..' //повторяем пока не найдём корень
  end;
 vUsr:=MidStr(usrList.Lines.strings[i],13,length(usrList.Lines.strings[i])-14); //получаем логин пользователя
 pSendData('0042',fGetUserIP(vUsr)); //посылаем пользователю сигнал разрыва
end;

procedure TMainFRM.btnRunSQLClick(Sender: TObject);
begin
 try
  ADOQuery1.SQL.Text:=txtSQL.Text;
   ADOQuery1.ExecSQL;
  pPutLogInfo('Сервер выполнил запрос',txtSQL.Text);
 except
  pPutLogInfo('Запрос с ошибкой!',txtSQL.Text);
 end;
end;

end.
