Imports System.Net
Imports System.Net.Sockets
Imports System.IO.File
Imports System.IO
Public Class FInet
    Dim LocHost As String
    Dim LocIpAdr As String
    Dim S1 As Integer = 2
    Dim S2 As String = "2"
    Dim FN As String
    Dim da As String
    'записывается и читается из файла
    Dim SAIP As String
    Dim SAAdress As String
    Dim SAHost As String
    'служба1
    Private Sub BackgroundWorker1_DoWork(sender As Object, e As System.ComponentModel.DoWorkEventArgs) Handles BackgroundWorker1.DoWork
        'служба1
        Dim Cl As New Net.WebClient
        Dim Lv As String
        Try
            Lv = Cl.DownloadString("http://www.msftncsi.com/ncsi.txt")
        Catch ex As Exception
            Cl.Dispose()
            S1 = 0
            Exit Sub
        End Try
        S1 = 1
        Cl.Dispose()
    End Sub
    'служба2
    Private Sub BackgroundWorker2_DoWork(sender As Object, e As System.ComponentModel.DoWorkEventArgs) Handles BackgroundWorker2.DoWork
        'служба2
        Try
            For Each IPAdress In System.Net.Dns.GetHostByName("dns.msftncsi.com").AddressList
                S2 = (IPAdress.ToString())
            Next
        Catch ex As Exception
            S2 = "0"
        End Try
        If S2 = "131.107.255.255" Then
            S2 = "1"
        End If
    End Sub
    'проверка интернета
    Private Sub Timer2_Tick(sender As Object, e As EventArgs) Handles Timer2.Tick
        Timer1.Start()
        If S1 = 0 And S2 = "1" Then
            tssStat.ForeColor = Color.DarkOrange
            tssStat.Text = "Отсутствует доступ"
            ToFileAdmin()
            S1 = 2
            S2 = "2"
            BackgroundWorker1.RunWorkerAsync()
            BackgroundWorker2.RunWorkerAsync()
        End If
        If S1 = 1 And S2 = "1" Then
            tssStat.ForeColor = Color.DarkGreen
            tssStat.Text = "Есть"
            Try
                ToFileAdminDel()
            Catch ex As Exception
            End Try

            S1 = 2
            S2 = "2"
            BackgroundWorker1.RunWorkerAsync()
            BackgroundWorker2.RunWorkerAsync()

        End If
        If S1 = 0 And S2 = "0" Then
            tssStat.ForeColor = Color.DarkRed
            tssStat.Text = "Нет"
            ToFileAdmin()
            S1 = 2
            S2 = "2"
            BackgroundWorker1.RunWorkerAsync()
            BackgroundWorker2.RunWorkerAsync()
        End If
        Timer2.Stop()
    End Sub
    'запускает таймеры
    Private Sub Timer1_Tick(sender As Object, e As EventArgs) Handles Timer1.Tick
        Timer2.Start()
        Timer3.Start()
        Timer1.Stop()
    End Sub
    'выход
    Private Sub ВыходToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ВыходToolStripMenuItem.Click
        Me.Close()
    End Sub
    'при загрузке
    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        'read
        ToFileRead()
        '
        da = SAAdress + "\Status"
        'запуск служб проверки
        BackgroundWorker1.RunWorkerAsync()
        BackgroundWorker2.RunWorkerAsync()
        Timer2.Start()
        'получение Hostnam и Ip данного ПК
        LocHost = System.Net.Dns.GetHostName()
        LocIpAdr = System.Net.Dns.GetHostByName(LocHost).AddressList(0).ToString
        Label1.Text = "Имя компьютера: " + (LocHost)
        Label2.Text = "IP-адрес: " + (LocIpAdr)
        'name
        FN = LocHost + "_" + LocIpAdr
        '
        Me.Text = "Клиент: " + LocHost
        ' запись
        ToFileAdd()
    End Sub
    'настройки
    Private Sub ИзменитьIpсервераToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ИзменитьIpсервераToolStripMenuItem.Click
        Pan.Visible = Not Pan.Visible
        If Pan.Visible = True Then
        Else
            Pan.Visible = False
        End If
        Label5.Text = "Админ: IP-" + SAIP + "; домен-" + SAHost
        Label6.Text = "Адрес посылки админу: " + SAAdress
    End Sub
    'измененние ip и домена админа
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        'закрытие панели
        Panel1.Visible = False
        'остановка служб
        Timer1.Stop()
        Timer2.Stop()
        Timer3.Stop()
        'замена
        If TextBox1.Text = "" Then
            MsgBox("Введите IP-adress админа")
        Else
            SAIP = TextBox1.Text
            ToFileAdd()
        End If
        'сохранение адресов
        If TextBox2.Text = "" Then
            MsgBox("Введите домен админа")
        Else
            SAHost = TextBox2.Text
            ToFileAdd()
        End If
        'запуск служб
        Timer1.Start()
        'возврат размера формы
        Height = 119
    End Sub
    'служба3
    Private Sub Timer3_Tick(sender As Object, e As EventArgs) Handles Timer3.Tick
        Dim SAIPAdres As String
        'служба3
        Try
            For Each IPAdress In System.Net.Dns.GetHostByName(SAHost).AddressList
                SAIPAdres = (IPAdress.ToString())
                If SAIPAdres = SAIP Then
                    tssStatA.ForeColor = Color.DarkGreen
                    tssStatA.Text = "На месте"
                    NI.Text = " "
                    NI.Text = "Интернет: " + tssStat.Text + "; Админ: На месте"
                End If
            Next
        Catch ex As Exception
            tssStatA.ForeColor = Color.DarkRed
            tssStatA.Text = "Нет на месте"
            NI.Text = " "
            NI.Text = "Интернет: " + tssStat.Text + "; Админ: нет на месте"
        End Try
        ToFileAdd()
        ToStatPK()
        Timer1.Start()
        Timer3.Stop()
    End Sub
    'адрес посылки отчётов
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        FBD.RootFolder = Environment.SpecialFolder.Desktop
        If FBD.ShowDialog = Windows.Forms.DialogResult.OK Then
            SAAdress = FBD.SelectedPath
        End If
    End Sub
    'запись
    Function ToFileAdd()
        'запись в файл
        If Exists("AdressPach.ini") Then
            FileClose()
            FileOpen(1, "AdressPach.ini", OpenMode.Output)
            PrintLine(1, SAIP)
            PrintLine(1, SAAdress)
            PrintLine(1, SAHost)
            FileClose()
        Else
            FileClose()
            FileOpen(1, "AdressPach.ini", OpenMode.Output)
            PrintLine(1, SAIP)
            PrintLine(1, SAAdress)
            PrintLine(1, SAHost)
            FileClose()
        End If
    End Function
    'чтение
    Function ToFileRead()
        Try
            'чтение
            FileClose()
            FileOpen(1, "AdressPach.ini", OpenMode.Input)
            SAIP = LineInput(1)
            SAAdress = LineInput(1)
            SAHost = LineInput(1)
            FileClose()
        Catch ex As Exception

        End Try
        
    End Function
    'посылка админу
    Function ToFileAdmin()
        FileClose()
        FileOpen(1, SAAdress + "\" + FN + ".text", OpenMode.Output)
        PrintLine(1, tssStat.Text)
        FileClose()
    End Function
    'удаление посылки
    Function ToFileAdminDel()
        FileClose()
        Try
            Delete(SAAdress + "\" + FN + ".text")
        Catch ex As Exception
            Label7.Text = "настройте программу. Укажите папку для посылок админу"

        End Try

    End Function
    'Статус
    Function ToStatPK()
        Dim UsEr As String = My.User.Name
        Try
            FileOpen(2, da + LocHost + ".txt", OpenMode.Output)
            PrintLine(2, My.User.Name)
            PrintLine(2, "в сети")
            FileClose()
        Catch ex As Exception

        End Try
        
    End Function
    'фоновый режим*
    Private Sub NotifyIcon1_MouseDoubleClick(sender As Object, e As MouseEventArgs) Handles NI.MouseDoubleClick
        Me.WindowState = FormWindowState.Normal
    End Sub
    'вход в фоновый режим
    Private Sub Form1_Resize(sender As Object, e As EventArgs) Handles MyBase.Resize
        If Me.WindowState = FormWindowState.Minimized Then
            ShowInTaskbar = False
        Else
            ShowInTaskbar = True
        End If
    End Sub
    'закрытие формы
    Private Sub FInet_FormClosed(sender As Object, e As FormClosedEventArgs) Handles MyBase.FormClosed
        'запись
        ToFileAdd()
        'удаление отчёта
        ToFileAdminDel()
    End Sub

End Class
