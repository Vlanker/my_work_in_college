Imports System.Net
Imports System.Net.Sockets
Imports System.IO
Imports System.IO.File
Public Class Form1
    Dim S1 As Integer = 2
    Dim S2 As String = "2"
    'write в файл
    Dim SAAdressPach As String
    'войсер и статус
    Dim a
    Dim da As String
    'кнопка выхода
    Private Sub ВыходToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ВыходToolStripMenuItem.Click
        Me.Close()
    End Sub
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
    'проверяет состояние интернета
    Private Sub Timer2_Tick(sender As Object, e As EventArgs) Handles Timer2.Tick
        'запуск проверки
        Timer1.Start()
        'Отсутствует доступ
        If S1 = 0 And S2 = "1" Then
            tssStat.ForeColor = Color.DarkOrange
            tssStat.Text = "Отсутствует доступ"
            a = CreateObject("sapi.spvoice")
            a.speak("Internet: Not available")
            S1 = 2
            S2 = "2"
            BackgroundWorker1.RunWorkerAsync()
            BackgroundWorker2.RunWorkerAsync()
        End If
        'Интернет есть
        If S1 = 1 And S2 = "1" Then
            tssStat.ForeColor = Color.DarkGreen
            tssStat.Text = "Есть"
            S1 = 2
            S2 = "2"
            BackgroundWorker1.RunWorkerAsync()
            BackgroundWorker2.RunWorkerAsync()
        End If
        'Интернета нет
        If S1 = 0 And S2 = "0" Then
            tssStat.ForeColor = Color.DarkRed
            tssStat.Text = "Нет"
            a = CreateObject("sapi.spvoice")
            a.speak("Internet: No internet. Urgent need to set up and return it, otherwise the workers will be screaming and swearing!")
            S1 = 2
            S2 = "2"
            BackgroundWorker1.RunWorkerAsync()
            BackgroundWorker2.RunWorkerAsync()
        End If
        'откл проверки
        Timer2.Stop()
    End Sub
    'запуск проверки
    Private Sub Timer1_Tick(sender As Object, e As EventArgs) Handles Timer1.Tick
        'запуск проверки
        Timer2.Start()
        'осановка запускатора
        Timer1.Stop()
    End Sub
    'при загрузке
    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        'приветствие
        a = CreateObject("sapi.spvoice")
        a.speak("Hello Admin. Lets go?")
        'read
        ToFileRead()
        Try
            'статус
            da = SAAdressPach + "\Status"
            Directory.CreateDirectory(da)
            '
        Catch ex As Exception

        End Try
        
        APMes.Text = SAAdressPach
        'запуск служб
        Timer2.Start()
        Timer3.Start()
        Timer4.Start()
        BackgroundWorker1.RunWorkerAsync()
        BackgroundWorker2.RunWorkerAsync()
        'write
        ToFileAdd()
        If My.Computer.Network.IsAvailable = False Then
            kkl.Text = "Не подключенно"
        Else
            kkl.Text = "Подключенно"
        End If
    End Sub
    'настройки
    Private Sub НастройкиToolStripMenuItem1_Click(sender As Object, e As EventArgs) Handles НастройкиToolStripMenuItem1.Click
        FB.RootFolder = Environment.SpecialFolder.Desktop
        If FB.ShowDialog = Windows.Forms.DialogResult.OK Then
            SAAdressPach = FB.SelectedPath
        End If
        APMes.Text = SAAdressPach
        ToFileAdd()
    End Sub
    'функция записи
    Function ToFileAdd()
        'запись в файл
        If Exists("AdressPach.ini") Then
            FileOpen(1, "AdressPach.ini", OpenMode.Output)
            PrintLine(1, SAAdressPach)
            FileClose()
        Else
            FileClose()
            FileOpen(1, "AdressPach.ini", OpenMode.Output)
            PrintLine(1, SAAdressPach)
            FileClose()
        End If
    End Function
    'функция чтения
    Function ToFileRead()
        'чтение
        FileOpen(1, "AdressPach.ini", OpenMode.Input)
        SAAdressPach = LineInput(1)
        FileClose()
    End Function
    'сохраняет всё при закрытии
    Private Sub Form1_FormClosed(sender As Object, e As FormClosedEventArgs) Handles MyBase.FormClosed
        a = CreateObject("sapi.spvoice")
        a.speak("You're leaving already? It's a shame ... Goodbye")
        'write при закрытии
        ToFileAdd()
    End Sub
    'служба3
    Private Sub Timer3_Tick(sender As Object, e As EventArgs) Handles Timer3.Tick
        'служба3
        Dim Files() As String

        Dim i As Integer
        Try
            TextBox1.Text = ""
            Files = Directory.GetFiles(SAAdressPach, "*.text")
            For i = 0 To Files.Length - 1
                TextBox1.Text = TextBox1.Text & Files(i) & vbCrLf
                Me.WindowState = FormWindowState.Normal
            Next i
        Catch ex As Exception
            TextBox1.Text = "Нет доступа"
        End Try
        NI.Text = ""
        NI.Text = "Интернет: " + tssStat.Text
        Timer3.Stop()
        Timer3.Start()
    End Sub
    'вход в фоновый режим
    Private Sub NotifyIcon1_MouseDoubleClick(sender As Object, e As MouseEventArgs) Handles NI.MouseDoubleClick
        Me.WindowState = FormWindowState.Normal
    End Sub
    'фоновый режим
    Private Sub Form1_Resize(sender As Object, e As EventArgs) Handles MyBase.Resize
        If Me.WindowState = FormWindowState.Minimized Then
            ShowInTaskbar = False
        Else
            ShowInTaskbar = True
        End If
    End Sub
    'Проверка любого IP или хоста, или сайта
    Private Sub IpадрессToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles IpадрессToolStripMenuItem.Click
        Panel1.Visible = Not Panel1.Visible
    End Sub
    'проверка
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Try
            For Each IPAdress In System.Net.Dns.GetHostByName(TextBox2.Text).AddressList
                Label2.Text = "Ответ: " + IPAdress.ToString()
            Next
        Catch ex As Exception
            Label2.Text = "Ответ: Нет ответа"
        End Try
    End Sub
    'замена
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        MsgBox("Функция получения ответа от сервера(ПК) в виде IP-адресса. Вводится IP-adress или Домен ПК, можно пропинговать сайт или сервер.")
    End Sub
    'служба4
    Private Sub Timer4_Tick(sender As Object, e As EventArgs) Handles Timer4.Tick
        'служба4
        Dim Stat() As String
        Dim StatOff() As String
        Dim k As Integer
        Dim a As String
        Dim b As String = "нет"
        k = 0
        Try
            Stat = Directory.GetFiles(da, "*.txt")
            For i = 0 To Stat.Length - 1
                FileOpen(i, Stat(i), OpenMode.Input)
                a = LineInput(i)
                TextBox3.Text = a + "Статус: " + LineInput(i)
                FileOpen(k, "iNoFF.ini", OpenMode.Output)
                PrintLine(k, a)
                PrintLine(k, b)
                FileClose(i)
                FileClose(k)
                Delete(Stat(i))
            Next
        Catch ex As Exception
        End Try
        Try
            StatOff = Directory.GetFiles(da, "*.ini")
            For k = 0 To k - 1
                FileOpen(k, StatOff(k), OpenMode.Input)
                TextBox3.Text = LineInput(k) + "Статус: " + LineInput(k)
            Next
        Catch ex As Exception
        End Try
        Timer4.Interval = 60000
    End Sub

End Class
