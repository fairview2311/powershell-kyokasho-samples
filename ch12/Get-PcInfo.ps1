# このパソコンの状態を表で見る
Write-Output "コンピューター名: $env:COMPUTERNAME"
Write-Output "ユーザー名: $env:USERNAME"

Write-Output ''
Write-Output 'メモリを多く使っているアプリ（上位5件）'
Get-Process |
    Sort-Object -Property WorkingSet64 -Descending |
    Select-Object -First 5 -Property Name, Id,
        @{ Name = 'メモリ(MB)'; Expression = { [int]($_.WorkingSet64 / 1MB) } } |
    Format-Table -AutoSize

Write-Output '自動で起動する設定なのに、停止しているサービス'
Get-Service |
    Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -ne 'Running' } |
    Select-Object -Property Name, DisplayName, Status |
    Format-Table -AutoSize
