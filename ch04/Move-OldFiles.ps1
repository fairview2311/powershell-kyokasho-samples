# 共有フォルダーの古いファイルを、最後に更新された年ごとのフォルダーに移す
$SharePath   = Join-Path $PSScriptRoot 'practice\share'
$ArchivePath = Join-Path $PSScriptRoot 'practice\archive'
$Days        = 365
$WhatIfMode  = $true    # 試すときは $true、本当に移すときは $false

$limit = (Get-Date).AddDays(-$Days)
$oldFiles = Get-ChildItem -Path $SharePath -Recurse -File |
    Where-Object { $_.LastWriteTime -lt $limit }

foreach ($file in $oldFiles) {
    $folder  = $file.Directory.Name
    $destDir = Join-Path $ArchivePath "$($file.LastWriteTime.Year)\$folder"
    New-Item -ItemType Directory -Path $destDir -Force -WhatIf:$WhatIfMode | Out-Null
    Move-Item -LiteralPath $file.FullName -Destination $destDir -WhatIf:$WhatIfMode
}

"対象: $(@($oldFiles).Count) 件（$($limit.ToString('yyyy/MM/dd')) より前に更新されたファイル）"
