# 売上の CSV を部署ごとに集計し、Excel で開ける CSV に書き出す
$InputPath  = Join-Path $PSScriptRoot 'data\uriage-202610.csv'
$OutputPath = Join-Path $PSScriptRoot 'output\部署別売上-202610.csv'

# 文字コードの名前は、5.1 と 7 で違う
if ($PSVersionTable.PSVersion.Major -ge 7) {
    $readEncoding  = 'Ansi'
    $writeEncoding = 'utf8BOM'
} else {
    $readEncoding  = 'Default'
    $writeEncoding = 'UTF8'
}

$rows = Import-Csv -Path $InputPath -Encoding $readEncoding

$summary = $rows | Group-Object -Property 部署 | ForEach-Object {
    [pscustomobject]@{
        部署     = $_.Name
        件数     = $_.Count
        合計金額 = [int]($_.Group | Measure-Object -Property 金額 -Sum).Sum
    }
}
$summary = $summary | Sort-Object -Property 合計金額 -Descending

New-Item -ItemType Directory -Path (Split-Path $OutputPath) -Force | Out-Null
$summary | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding $writeEncoding

$summary | Format-Table -AutoSize
"書き出しました: $OutputPath"
