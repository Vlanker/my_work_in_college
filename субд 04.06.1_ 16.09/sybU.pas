unit sybU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, Grids, DBGrids, ExtCtrls, DBCtrls, Menus,ShellAPI,//��� ���
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
    //��� ������ � �����
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
  //�� ����������� ��� "���. �����"
  but:Boolean;
  vx,vy:integer;
  //��� �������
  TAbleName:string;

  //��� �����������
   vUserName:String;
   vPassword:String;
    vDBPath:String;
implementation

uses StrUtils;

{$R *.dfm}
//==����================================
procedure TForm1.IconMouse(var Msg:TMessage);
Var p:tpoint;
begin
 GetCursorPos(p); // ���������� ���������� ������� ����
 Case Msg.LParam OF  // ��������� ����� ������ ���� ������
  WM_LBUTTONUP,WM_LBUTTONDBLCLK: {��������, ����������� �� ���������� ��� �������� ������ ����� ������ ���� �� ������. � ����� ������ ��� ������ ��������� ����������}
                   Begin
                    Ic(2,Application.Icon);  // ������� ������ �� ����
                    ShowWindow(Application.Handle,SW_SHOW); // ��������������� ������ ���������
                    ShowWindow(Handle,SW_SHOW); // ��������������� ���� ���������
                    Update;
                   End;
  WM_RBUTTONUP: {��������, ����������� �� ���������� ������ ������ ������ ����}
   Begin
    SetForegroundWindow(Handle);  // ��������������� ��������� � �������� ��������� ����
    pmTreyMenu.Popup(p.X,p.Y);  // ���������� ������� ���� PopMenu
    PostMessage(Handle,WM_NULL,0,0);
   end;
 End;
end;
//��� ����������� ����
Procedure TForm1.OnMinimizeProc(Sender:TObject);
Begin
 PostMessage(Handle,WM_SYSCOMMAND,SC_MINIMIZE,0);
End;
//����� ��������
Procedure TForm1.ControlWindow(Var Msg:TMessage);
Begin
 IF Msg.WParam=SC_MINIMIZE then
  Begin
   Ic(1,Application.Icon);                    // ��������� ������ � ����
   ShowWindow(Handle,SW_HIDE);                // �������� ���������
   ShowWindow(Application.Handle,SW_HIDE);  // �������� ������ � TaskBar'�
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
   szTip :='���������� (Lib-Client)';
  End;
 Case n OF
  1: Shell_NotifyIcon(Nim_Add,@Nim);
  2: Shell_NotifyIcon(Nim_Delete,@Nim);
  3: Shell_NotifyIcon(Nim_Modify,@Nim);
 End;
end;

//=====================================

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
     form1.DataSource1.DataSet.Fields.Fields[i].DisplayWidth := 14 //������ �������
    else form1.DataSource1.DataSet.Fields.Fields[i].DisplayWidth := 2 ;;//������ �������
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
     form1.DataSource1.DataSet.Fields.Fields[i].DisplayWidth := 14 //������ �������
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
 vData:=fCodeBin(vStr,'000#code#local'); //������� ������
  form1.CSock.Socket.SendText(vData); //�������� ��������
 end;
end;

procedure pRunSQL(vCode:string);
begin
 SendTextToServer('0008'+vCode);//�������� ������� ������
end;

procedure pRunClient(vDataCode:String);  //������� � �������� �� ������
var vUserCode:Integer;vQuerText:String;
begin
 vUserCode:=StrToInt(LeftStr(vDataCode,4)); //��������� ���
 vQuerText:=RightStr(vDataCode,Length(vDataCode)-4); //��������� ������
  case vUserCode of
  7000: begin //������ ��� �������������
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
   form1.StatusBar1.Panels[5].Text:='������� �������';
   form1.StatusBar1.Panels[5].Text:='���� ��������';
  end;
  7024: begin //������ ��������� ������ � ������� �������� ���
         form1.qy1.Active:=false;
         form1.qy1.SQL.Clear;
         form1.qy1.SQL.Add('select * from '+TableName);
         form1.qy1.ExecSQL;
         form1.qy1.Active:=true;
         form1.Button6.Click;
         form1.DBGrid1.Refresh;
         form1.StatusBar1.Panels[3].Text:='������ ������ � ������� ��������';
        end;
   0014: SendTextToServer('0015'); //������������ ����������
   0042: begin ShowMessage('������������� �������� ����������');
               form1.close;
         end;
   8000:begin
     form1.StatusBar1.panels[1].Text:='������ �� ���������� �����������!';
     ShowMessage(form1.StatusBar1.panels[1].Text);
     form1.StatusBar1.Panels[5].Text:='��� ������� � ����';
    end;
   8001: begin
     form1.StatusBar1.panels[1].Text:='��������� ������� ������ ��� ������';
     ShowMessage(form1.StatusBar1.panels[1].Text);
     form1.StatusBar1.Panels[5].Text:='��� ������� � ����';
    end;
   8002:begin
     form1.StatusBar1.panels[1].Text:='��������� ������� ������ �����!';
     ShowMessage(form1.StatusBar1.panels[1].Text);
     form1.StatusBar1.Panels[5].Text:='��� ������� � ����';
    end;
   8023:begin

     form1.StatusBar1.panels[3].Text:='� ������� ���������� �������������� ������!';
     ShowMessage(form1.StatusBar1.panels[3].Text);
    end;
   8024:begin

     form1.StatusBar1.panels[1].Text:='�� ���������� ������� ��� ����, �������� �����������!';
     ShowMessage(form1.StatusBar1.panels[1].Text);
          form1.StatusBar1.Panels[5].Text:='��� ������� � ����';
    end;
  else
    //������������, ���������� ������ ������� �� ��������
   form1.StatusBar1.panels[1].Text:='������ �����';
   ShowMessage(form1.StatusBar1.panels[3].Text);
  end;
end;

procedure loadSettings(FileName:string);//��������� ������������ ������
 var vF:TextFile;vT:String;
begin
 AssignFile(vF,FileName);
  ReSet(vF);
 repeat
  Readln(vF,vT);
   if LeftStr(vT,5)='port=' then form1.CSock.Port:=strtoint(RightStr(vT,length(vT)-5));  //����
   if LeftStr(vT,7)='server=' then form1.CSock.Host:=RightStr(vT,length(vT)-7);   //IP
   if LeftStr(vT,5)='name=' then form1.Caption:=RightStr(vT,length(vT)-5);//��� ���������
   if LeftStr(vT,6)='table=' then TableName:=RightStr(vT,length(vT)-6);   //��� �������
 until Eof(vF);
 CloseFile(vF);
end;

{==== ������� ������� ������� ��� ��������(�����������,��������,�������)�
 ��� �������� ��������====}
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
form1.StatusBar1.Panels[1].Text:='�����������';
form1.StatusBar1.Panels[3].Text:='�������';
end;

//���������� ����
procedure TForm1.N5Click(Sender: TObject);
begin
PnWIL(1);

end;

//�������� ������������
procedure TForm1.Button1Click(Sender: TObject);
begin
 PnWIL(0);
end;

 //����. ���������� �������
procedure TForm1.Button2Click(Sender: TObject);
 var BdType:string;
begin
//� ������ �������  ��������
if (ENS.Text ='') or (ts.Text ='') then
 begin
  StatusBar1.Panels[1].Text:='������� �������� �������!';
  ShowMessage(StatusBar1.Panels[1].Text);
 end
else
//���� ������
case ts.ItemIndex of
 0: BdType:='string';
 1: BdType:='integer';
 2: BdType:='datetime';
else
 BdType:='string';
end;
//������ �� ���������� ����
 pRunSQL('ALTER TABLE '+TableName+' ADD '+ENS.Text+' '+BdType );
end;

//�����������
procedure TForm1.N10Click(Sender: TObject);
begin
PnWIL(2);
end;

//����� ���� � ������ �� ����
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

//����.�����
procedure TForm1.FormCreate(Sender: TObject);
begin
try
vUserName:=InputBox('�����������','������� �����','');
vPassword:=InputBox('�����������','������� ������','');
loadSettings('settings.ini'); // ��������� ������������ ������
CSock.Close;
CSock.Open; // ��������� ����������
memo1.Lines.Add('Select * From '+TableName);
timer1.Enabled:=true;
ReSizeTable;
except
 ShowMessage('����������� � ������� �� ���� ������������');
 form1.StatusBar1.Panels[5].Text:='����������� � ������� �� ���� ������������!';
end;

end;

// p1
procedure TForm1.Button4Click(Sender: TObject);
begin
PnWIL(0);
end;

//�����
procedure TForm1.Button3Click(Sender: TObject);
var
  i : integer;
begin
  qy1 .Active := false;
//������
if Panel3.Visible then  begin
  qy1.SQL.Strings[1] :='Where '+ComboBox1.Text +' Like "%'+Edit6.Text+'%"';
  end;
//����
if Panel4.Visible then
  qy1.SQL.Strings[1] := 'Where [' +ComboBox1.Text + '] between '+DateToStr(DateTimePicker1.Date)+' And '+DateToStr(DateTimePicker1.Date);
//�����
if Panel2.Visible then
 if RadioButton1.Checked then
  qy1.SQL.Strings[1] := 'Where [' +ComboBox1.Text+ '] Like ' +  Edit1.Text;
//��������
 if RadioButton2.Checked then
   qy1.SQL.Strings[1] := 'Where [' +ComboBox1.Text + '] between '+Edit2.Text+' And '+Edit3.Text;
qy1.Active := true;
  for i := 0 to DataSource1.DataSet.FieldCount-1  do
    DataSource1.DataSet.Fields.Fields[i].DisplayWidth := 14;
end;

//����������
procedure TForm1.N12Click(Sender: TObject);
begin
  Button6.Click;
end;

//����� ��� ��������� ��������
{���������----}
procedure TForm1.RadioButton1Click(Sender: TObject);
begin
if RadioButton1.Checked then
  begin
    GroupBox1.Enabled := False ;
    GroupBox2.Enabled := True ;
  end;
end;
{��������----}
procedure TForm1.RadioButton2Click(Sender: TObject);
begin
if RadioButton2.Checked then
  begin
   GroupBox1.Enabled := True;
   GroupBox2.Enabled := false;
  end;
end;

{������� ������ � Enter------------}
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

//���������� ������� �������
procedure TForm1.Button5Click(Sender: TObject);
begin
 pRunSQL(Memo1.Text);
end;

//������ ������
procedure TForm1.N11Click(Sender: TObject);
begin
panel5.Visible :=true;
end;
procedure TForm1.XClick(Sender: TObject);
begin
panel5.Visible :=false;
//������ ���� ������� �����
memo1.Clear;
//����������� ����� �������
Memo1.Lines.Add('Select * From '+TableName);
 form1.StatusBar1.Panels[1].Text:='���';
end;

//������������ ���� "������� �����"
procedure TForm1.Panel5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
vx:= x;//���������� ���������� ������
vy:= y ;
but := true;
end;
procedure TForm1.Panel5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var tx,ty:integer;
begin
if but = true then
  begin
    tx := Panel5.left + x -vx ;//���������� �
    ty := Panel5.top + y  - vy;//���������� �
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
//�������� ������ � �������
procedure TForm1.Button6Click(Sender: TObject);
begin
 qy1.Active:=false;
 qy1.SQL.Clear;
 qy1.SQL.Add('select * from '+TableName);
 qy1.ExecSQL;
 qy1.Active:=true;
// form1.DBGrid1.Refresh;
 ReSizeTable;//�������� ��������  � ������� � ������ ��������
end;
//������� ������
procedure TForm1.Button7Click(Sender: TObject);
begin
pRunSQL('iNSERT INTO ['+TAbleName+'] default values');
end;
//�������� ������
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
// ��������  �������
procedure TForm1.Button10Click(Sender: TObject);
begin//
if ComboBox2.Text ='' then
 begin
   ShowMessage('�������� �������!!!');
   StatusBar1.Panels[1].Text:='�������� �������!!!'
 end
else //������������ �������
  pRunSQL('alter table '+TableName+' drop ['+combobox2.Text+']' );
end;

procedure TForm1.N14Click(Sender: TObject);
begin
Ic(2,Application.Icon);//!!
close;
end;

procedure TForm1.N7Click(Sender: TObject);
begin //������ �����.���\����
List.Visible:=not List.Visible;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin //������ �����.���\����
List.Visible:=not List.Visible;
end;

procedure TForm1.ListExit(Sender: TObject);
begin //������ �����.����
List.Visible:=false;
end;

procedure TForm1.ListClick(Sender: TObject);
var i:integer;
 vSQ:String;
begin
qy1.Active:=false;//���� Sql
qy1.SQL.Clear;//�������
{������������ �������}
vSQ:='select ';//������� ��������� ����
for i :=0 to list.Items.Count-1 do
 if list.Selected[i] then vsQ:=vsQ+'['+TableName+'].['+list.Items[i]+'], ';
vsQ:=LeftStr(vSQ,length(vSQ)-2)+' From '+TableName;//�������� �������� 2 ��������
qy1.SQL.Add(vsQ);//������� ������� �� �����������
qy1.Active:=true;//��������� Sql
ReST;//�������� ������� � ������ ��� "�������"
end;

procedure TForm1.CSockConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
//������ � ������ ��������� Ip-�������
statusbar1.Panels.Items[5].Text:='�������. Ip-c�����a('+socket.LocalAddress+')';
end;
//������ ���������� ��������� �� �������
procedure TForm1.CSockRead(Sender: TObject; Socket: TCustomWinSocket);
 var vData:String;
begin
 vData:=Socket.ReceiveText;//����������� ����� ��� ���������
 vData:=fUnCodeBin(vData,'000#code#local'); //���������
 pRunClient(vData); //��������
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 SendTextToServer('4004'); //������
end;
//��� ��������� �����������
procedure TForm1.Timer1Timer(Sender: TObject);
begin
try                    //����������� �������� ��� � ������ � ���� ������
 SendTextToServer('0000'+vUserName+';'+vPassword);
 Timer1.Enabled:=false;
except       //� ������ ������
 ShowMessage('������ ����������');
 form1.StatusBar1.Panels[5].Text:='������ ����������!';
end;
end;
//��������� �����������
procedure TForm1.N15Click(Sender: TObject);
begin
//�������������� ������ ���������
form1.StatusBar1.Panels[1].Text:='���';
form1.StatusBar1.Panels[3].Text:='��������';
form1.StatusBar1.Panels[5].Text:='�������� �����������';
//==
SendTextToServer('4004'); //������
form1.DBGrid1.DataSource.Enabled:=false;//��������� ������� ����
form1.qy1.Active:=false;//��� sql
form1.ADOConnection1.Connected:=False;//��� ��� � �����
vUserName:=InputBox('�����������','������� �����','');
vPassword:=InputBox('�����������','������� ������','');
Timer1.Enabled:=True;//��������� ������ �����������
end;
//������ � �������
procedure TForm1.CSockError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  case ErrorCode of
   10061:begin
     ShowMessage('������ �� ��������!');
     form1.StatusBar1.Panels[5].Text:='������ �� ��������!';
     ErrorCode:=0;//���������� ������ � �, ���� ��� �� �����������
    end;
    10060: begin
            form1.StatusBar1.Panels[5].Text:='����������� ����������!';
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
ShowMessage('���������� ������ "'+ form1.Caption+'". �������� ��������� ������������� � "����������� ������������"');
end;

end.
