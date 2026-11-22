' ディスクの空きを調べて、少なければログに書く（前任者 作）
Option Explicit
Dim wmi, disks, disk, freePct, fso, logFile

Set wmi = GetObject("winmgmts:\\.\root\cimv2")
Set disks = wmi.ExecQuery("SELECT * FROM Win32_LogicalDisk WHERE DriveType = 3")
Set fso = CreateObject("Scripting.FileSystemObject")
Set logFile = fso.OpenTextFile(fso.GetParentFolderName(WScript.ScriptFullName) & "\diskcheck.log", 8, True)

For Each disk In disks
    freePct = Int(disk.FreeSpace / disk.Size * 100)
    WScript.Echo disk.DeviceID & " の空き: " & freePct & "%"
    If freePct < 15 Then
        logFile.WriteLine Now & " [WARN] " & disk.DeviceID & " の空きが " & freePct & "% です"
    End If
Next

logFile.Close
