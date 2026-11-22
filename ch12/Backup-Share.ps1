# 練習用の共有フォルダーを、日付つきのフォルダーにバックアップする（old\backup.bat の書き換え）
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$Path = (Join-Path $PSScriptRoot 'practice\share'),
    [string]$Destination = (Join-Path $PSScriptRoot 'backup'),
    [int]$KeepDays = 30
)

Import-Module (Join-Path $PSScriptRoot 'MidoriTools') -Force

# 今日の日付のフォルダーにコピーする
$target = Join-Path $Destination ('share-{0:yyyyMMdd}' -f (Get-Date))
New-Item -Path $target -ItemType Directory -Force | Out-Null
Copy-Item -Path (Join-Path $Path '*') -Destination $target -Recurse -Force
Write-MidoriLog -Message "バックアップしました: $target"

# KeepDays 日より古いバックアップを削除する
$limit = (Get-Date).AddDays(-$KeepDays)
Get-ChildItem -Path $Destination -Directory -Filter 'share-*' |
    Where-Object { $_.LastWriteTime -lt $limit } |
    Remove-Item -Recurse
