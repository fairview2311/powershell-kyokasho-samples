# ディスクの空きを一覧にする
$disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
foreach ($d in $disks) {
    $label = if ($d.VolumeName) { $d.VolumeName } else { '(なし)' }
    [pscustomobject]@{
        ドライブ = $d.DeviceID
        ラベル   = $label
        空きGB   = [math]::Round($d.FreeSpace / 1GB, 1)
    }
}
