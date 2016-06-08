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
  mainfrm.usrList.Lines.Add('.. �����: <.'+vUserList[i].uLogin+'.>');
   if vUserList[i].uAccess then begin
    mainfrm.usrList.Lines.Add(' ������: <�������>'+vT);
    mainfrm.usrList.Lines.Add('  [������] = 1;');
    mainfrm.usrList.Lines.Add('  [����] = '+inttostr(vUserList[i].uRang)+';');
    mainfrm.usrList.Lines.Add(' �����:');
    mainfrm.usrList.Lines.Add('  [IP] = |'+vUserList[i].uIP+'|;');
    mainfrm.usrList.Lines.Add('  [����] = 101;');
   end
   else begin
    mainfrm.usrList.Lines.Add(' ������: <�� � ����>'+vT);
    mainfrm.usrList.Lines.Add('  [������] = 0;');
   end;
 end;
 for i:=1 to MainFRM.usrList.Lines.Count do //���������� ��� ��������
  mainfrm.usrList.Items[i].FullExpand;  //���������� �� ������� ������
mainfrm.usrList.SelectedItem:=vSelI;
end;

//= �������� ������ ������������� =======================================
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

//= �������������� ������� ������������ =================================
function fAddUser(nAutoris:string;nIP:String):Integer;
 var i:integer;
begin
fAddUser:=0; //���������� � ������� 0
 if nAutoris=';' then begin //���� ������������ �� ������ ��������������� ������
   fAddUser:=3; //���������� ��� 3
  exit; //����������� �������� �������
 end;
 for i:=0 to vUserCount do //������������ ������ �������������
  if (vUserList[i].uLogin+';'+vUserList[i].uPassword=nAutoris)then begin //���� ������������ ������ �����������
   if not vUserList[i].uAccess then begin //���������, ������� �� ������ ������ ������������ �����
    vUserList[i].uIP:=nIP;vUserList[i].uAccess:=True; //���������� IP ������������� ������������
    fAddUser:=1; //������� ������������ ������� ������ ������������ � ������
   break; //����� �� �������
   end //������� �������� �������
   else fAddUser:=2; //������������ ��� ������������� �����
  end;
end;//===================================================================

//= ������� ������ ������� ������������ ================================
function fGetUserAccess(nIP:String):Boolean; //� �������� ��������� IP �����
 var i:integer; //������� ��� �������
begin
 for i:=0 to vUserCount do //������������ ���� ��������
  if vUserList[i].uIP=nIP then begin //���� ������ ������
   fGetUserAccess:=vUserList[i].uAccess; //��������� ��� ������ � return
   break; //����� �� �����
  end;  //������� ������������
end;//===================================================================

//= ������� ������ IP ������ ������������ ===============================
function fGetUserIP(nLogin:String):String; //� �������� ��������� �����
 var i:integer; //������� ��� �������
begin
 for i:=0 to vUserCount do //������������ ���� ��������
  if vUserList[i].uLogin=nLogin then begin //���� ������ ������
   fGetUserIP:=vUserList[i].uIP; //��������� ��� �����
   break; //����� �� �����
  end;  //������� ������������
end;//===================================================================

//= ������� ������ ������ ������������ ==================================
function fGetUserName(nIP:String):String; //� �������� ��������� �����
 var i:integer; //������� ��� �������
begin
 for i:=0 to vUserCount do //������������ ���� ��������
  if vUserList[i].uIP=nIP then begin //���� ������ ������
   fGetUserName:=vUserList[i].uLogin; //��������� ��� �����
   break; //����� �� �����
  end;  //������� ������������
end;//===================================================================

//= ������� ������ ������ ������ ������������ ===========================
function fGetUserPassword(nIP:String):String; //� �������� ��������� �����
 var i:integer; //������� ��� �������
begin
 for i:=0 to vUserCount do //������������ ���� ��������
  if vUserList[i].uIP=nIP then begin //���� ������ ������
   fGetUserPassword:=vUserList[i].uPassword; //��������� ��� �����
   break; //����� �� �����
  end;  //������� ������������
end;//===================================================================

//= ��������� ������������ ������������ =================================
procedure pSetUserDisconnect(nIP:String);
 var i:integer; //������� ��� �������
begin
 for i:=0 to vUserCount do //������������ ���� ��������
  if vUserList[i].uIP=nIP then begin //���� ������ ������
   vUserList[i].uAccess:=false; //������� ������
   break; //����� �� �����
  end;  //������� ������������
end;//===================================================================

//= �������� ������������ ������������� =================================
procedure pLoadPath(filename:String);
 var vT:String;vF:TextFile; //��������� �� �������� ����
begin
 AssignFile(vF,filename); //���� ���������
 ReSet(vF); //����� �������
  ReadLn(vF,vT); //���������� ��������
   vDBPath:=vT; //�����������
 CloseFile(vF); //�������� ����� � ������� ���������
end;//===================================================================

//= ����������� ������ ==================================================
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

//= ���������� ������ ===================================================
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

//= ������������� ������� ===============================================
function StartServer(vPort:Integer):Boolean;
begin
 MainFRM.ServerSocket.Close; //��������� ����������
 MainFRM.ServerSocket.Port:=vPort; //������������� ������� ����
 MainFRM.ServerSocket.Open; //��������� ����
  StartServer:=MainFRM.ServerSocket.Active; //������� ���������� � �������
end;//===================================================================

//= ������ ������� ======================================================
procedure pSendData(vText:String;Client:string);
 var I:Integer; //������� ��������
begin
try
vText:=fCodeBin(vText,'000#code#local'); //���� ������
 for i:=0 to mainfrm.ServerSocket.Socket.ActiveConnections-1 do //��������� ���� ��������
  if mainfrm.ServerSocket.Socket.Connections[i].RemoteAddress=Client then begin //���� ��� ������ ������
    mainfrm.ServerSocket.Socket.Connections[i].SendText(vText); //�������� ��� �����
    break; //������� �� �����
   end; //������� �������
except
 pPutLogInfo('������ �������� ������',Client);
end;
end;//===================================================================

//= �������� ���������� ������������� ===================================
procedure TMainFRM.tPingTimer(Sender: TObject);
begin
 if vUserList[vCurrentUserPing].uAccess then begin //��������� ������
  pSendData('0014',vUserList[vCurrentUserPing].uIP); // �������� ������������ ������
 tTimeOut.Enabled:=true; //��������� � ����� ��������
 tPing.Enabled:=false; //���������������� ����
 end;
end;//===================================================================

//= ������������� ������� ������� =======================================
procedure RunServer(vDataCode:String;ClientSocket:TCustomWinSocket);
var vUserCode:Integer;vQuerText:String;vErr:Integer;
begin
 try //���������� ������
 vUserCode:=StrToInt(LeftStr(vDataCode,4)); //��������� ���
 except
 vUserCode:=-1; //���������� ��� ��������
  pPutLogInfo('�������������� ������',vDataCode); //���������� ������� � ������
 end;
 vQuerText:=RightStr(vDataCode,Length(vDataCode)-4); //��������� ������
  Case vUserCode of  //��������� ���
    0000: begin //������ �����������
    pPutLogInfo('������ �����������','������ '+ClientSocket.RemoteAddress); //���������� ������� � ������
      case fAddUser(vQuerText,ClientSocket.RemoteAddress) of //�������� �������� ������������
       0: begin
       pShowAccesList; //��������� ������ ��������
        pSendData('8000',ClientSocket.RemoteAddress); //�������� ������� �� ������ �����������
         pPutLogInfo('����� � �������','������ ������� '+vQuerText); //���������� ������� � ������
       end;
       1: begin
       pShowAccesList; //��������� ������ ��������
        pSendData('7000'+vDBPath+';User ID='+fGetUserName(ClientSocket.RemoteAddress)+';Password='+fGetUserPassword(ClientSocket.RemoteAddress),ClientSocket.RemoteAddress); //����������  ������� �������������
         pPutLogInfo('������ �������������','������ ������� '+vQuerText); //���������� ������� � ������
       end;
       2: begin
       pShowAccesList; //��������� ������ ��������
        pSendData('8001',ClientSocket.RemoteAddress); //�������� ������� � ���, ��� ������� ������ ������
         pPutLogInfo('������� ������ ������','������ ������� '+vQuerText); //���������� ������� � ������
       end;
       3: begin
       pShowAccesList; //��������� ������ ��������
        pSendData('8002',ClientSocket.RemoteAddress); //�������� ������� � ���, ��� ������������ �������, ������� ������
         pPutLogInfo('������ �������������','������ ������� '+vQuerText); //���������� ������� � ������
       end;
      end;
    end;
    0015: begin //���� ������������ �������
      inc (vCurrentUserPing); //��������� � ���������� ������������
     mainfrm.tTimeOut.Enabled:=False; //��������� ���� -���
     mainfrm.tPing.Enabled:=True; //���������� ����, �������� ������ ������� ������������
    end;
    4004: pSetUserDisconnect(ClientSocket.RemoteAddress); //������������ ����������
    0008: begin //������ ���������� SQL
     if fGetUserAccess(ClientSocket.RemoteAddress) then begin //��������� ������ ������� � ����
      try
        mainfrm.ADOQuery1.SQL.Text:=vQuerText; //���������� ��� �������
        mainfrm.ADOQuery1.ExecSQL; //�������� ������ �� ������������ ��������
         Application.ProcessMessages; //�������� ����������
          sleep(100); //��� ���� ������ � ���������...
        pPutLogInfo('��������� ������',vQuerText); //���������� ������� � ������
       pSendData('7024',ClientSocket.RemoteAddress) // ���������� ������� ��������� �� �������� ���������� �������
      except
        pPutLogInfo('������� ���������� ������, ��������� �������',vQuerText); //���������� ������� � ������
       pSendData('8023',ClientSocket.RemoteAddress); // ���������� ������� ��������� � ������ ���������� �������
      end;
      end
     else begin
       pPutLogInfo('������� ���������� ������, ��������� � �������','|'+ClientSocket.LocalAddress+'| :: '+vQuerText);
      pSendData('8024',ClientSocket.RemoteAddress); //���������� ������� ������ �������
     end;
    end;
  end;
end;//===================================================================

//= ��������� ������ �� �������� ========================================
procedure TMainFRM.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var vData:String; //������ ������
begin
vData:=Socket.ReceiveText; //�������� ������ � ������
vData:=fUnCodeBin(vData,'000#code#local'); //�������������� �����
 RunServer(vData,Socket); //�������� � ��������
end;//===================================================================

procedure TMainFRM.btnLoadClick(Sender: TObject);
begin
btnUnload.Enabled:=true;btnLoad.Enabled:=false; //������ ������� ��� ������
 StartServer(101); //��������� ������
  caption:= ServerSocket.Socket.LocalHost + ' - ������ ������!'; //
  try
   ADOConnection1.ConnectionString:=vDBPath; //��������� �������������
   ADOConnection1.Connected:=True; //��������� ���������� � SQL ��������
   tping.Enabled:=true; //�������� �������� ����
   pPutLogInfo('����������� ��� ������',''); //���������� ������� � ������
  Except
   pPutLogInfo('���� ������ �� ���� ����������',vDBPath); //���������� ������� � ������
  end;
 pShowAccesList; //��������� ������ ��������
end;

procedure TMainFRM.FormCreate(Sender: TObject);
begin
vCurrentUserPing:=0; //�������� ���� � ������� ������������
 pInitUserList('UserList.txt'); //��������� ������ �������������
 pLoadPath('Path.txt'); //��������� �������������
pPutLogInfo('����� �������',''); //���������� ������� � ������
end;

procedure TMainFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree; //��� �������� �����, ��������� ���������� �� ������
end;


procedure TMainFRM.btnUnloadClick(Sender: TObject);
begin
 close;
end;

procedure TMainFRM.tTimeOutTimer(Sender: TObject);
begin
 vUserList[vCurrentUserPing].uAccess:=False; //��������� ������ ������������
  pShowAccesList; //��������� ������ ��������
 inc (vCurrentUserPing); //��������� � ���������� ������������
 if vCurrentUserPing>vUserCount then vCurrentUserPing:=0; //���� ������������ ���������, �������� � ������
  tTimeOut.Enabled:=False; //��������� ����-���
  tPing.Enabled:=True; //�������� ����
end;

procedure TMainFRM.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
pShowAccesList; //��������� ������ ��������
 pPutLogInfo('������ ������'+#13+#10+'err '+inttostr(ErrorCode)+'#','������ |'+Socket.LocalAddress+'|'); //���������� ������� � ������
end;

procedure TMainFRM.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
pShowAccesList; //��������� ������ ��������
 pPutLogInfo('����������� �������','������ |'+Socket.RemoteAddress+'|'); //���������� ������� � ������
end;

procedure TMainFRM.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
pShowAccesList; //��������� ������ ��������
 pPutLogInfo('������������ �������','������ |'+Socket.RemoteAddress+'|'); //���������� ������� � ������
end;


procedure TMainFRM.btnClearClick(Sender: TObject);
begin
 pPutLogInfo('',''); //������� �����
end;

procedure TMainFRM.btnOpenClick(Sender: TObject);
begin
 ShellExecute(Handle, 'open', 'log\', nil, nil, SW_SHOWNORMAL) //������ ����������
end;

procedure TMainFRM.btnKickClick(Sender: TObject);
 var i:Integer;vUsr:String;
begin
 i:=usrlist.SelectedItem-1; //���������� ��������� ������
  if LeftStr(usrList.Lines.Strings[i],2)<>'..' then begin //���������, �� �������� �� ��� ������
   repeat
    i:=i-1;//���� �� ������, ���������� ���� �������
   until LeftStr(usrList.Lines.Strings[i],2)='..' //��������� ���� �� ����� ������
  end;
 vUsr:=MidStr(usrList.Lines.strings[i],13,length(usrList.Lines.strings[i])-14); //�������� ����� ������������
 pSendData('0042',fGetUserIP(vUsr)); //�������� ������������ ������ �������
end;

procedure TMainFRM.btnRunSQLClick(Sender: TObject);
begin
 try
  ADOQuery1.SQL.Text:=txtSQL.Text;
   ADOQuery1.ExecSQL;
  pPutLogInfo('������ �������� ������',txtSQL.Text);
 except
  pPutLogInfo('������ � �������!',txtSQL.Text);
 end;
end;

end.
