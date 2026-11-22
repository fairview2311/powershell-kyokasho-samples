# 第4章の練習用の共有フォルダーを作る（何度実行しても、同じ状態に作り直す）
$Share = Join-Path $PSScriptRoot 'practice\share'

if (Test-Path $Share) {
    Remove-Item -Path $Share -Recurse -Force
}

$files = @(
    @{ Path = '総務部\社内報_2023年4月号.pdf';     Date = '2023-04-10' }
    @{ Path = '総務部\備品の注文書_2023-11.xlsx'; Date = '2023-11-20' }
    @{ Path = '総務部\防災訓練の案内.docx';        Date = '2024-08-30' }
    @{ Path = '総務部\社内報_2026年10月号.pdf';    Date = '2026-10-05' }
    @{ Path = '営業部\見積書_A社_2024-02.xlsx';    Date = '2024-02-14' }
    @{ Path = '営業部\訪問記録_2025年.docx';       Date = '2025-06-12' }
    @{ Path = '営業部\見積書_B社_2026-11.xlsx';    Date = '2026-11-02' }
    @{ Path = '経理部\経費精算_2023年度.xlsx';     Date = '2024-03-29' }
    @{ Path = '経理部\請求書_2025-09.pdf';         Date = '2025-09-30' }
    @{ Path = '経理部\請求書_2026-10.pdf';         Date = '2026-10-31' }
)

foreach ($f in $files) {
    $path = Join-Path $Share $f.Path
    New-Item -ItemType File -Path $path -Force | Out-Null
    Set-Content -Path $path -Value "練習用のファイルです: $($f.Path)"
    (Get-Item -Path $path).LastWriteTime = [datetime]$f.Date
}

Get-ChildItem -Path $Share -Recurse -File |
    Select-Object -Property @{ Name = 'フォルダー'; Expression = { $_.Directory.Name } }, Name, LastWriteTime |
    Format-Table -AutoSize
