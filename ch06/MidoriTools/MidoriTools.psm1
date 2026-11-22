# みどり文具の作業箱（モジュール）

function Get-MidoriEncoding {
    # 5.1 と 7 で名前が違う文字コードを、読み込み用と書き出し用の組で返す
    if ($PSVersionTable.PSVersion.Major -ge 7) {
        [pscustomobject]@{ Read = 'Ansi'; Write = 'utf8BOM' }
    } else {
        [pscustomobject]@{ Read = 'Default'; Write = 'UTF8' }
    }
}

function Get-SalesSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [string]$OutputPath
    )

    $encoding = Get-MidoriEncoding
    $rows = Import-Csv -Path $Path -Encoding $encoding.Read

    $summary = $rows | Group-Object -Property 部署 | ForEach-Object {
        [pscustomobject]@{
            部署     = $_.Name
            件数     = $_.Count
            合計金額 = [int]($_.Group | Measure-Object -Property 金額 -Sum).Sum
        }
    }
    $summary = $summary | Sort-Object -Property 合計金額 -Descending

    if ($OutputPath) {
        New-Item -ItemType Directory -Path (Split-Path $OutputPath) -Force | Out-Null
        $summary | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding $encoding.Write
    }

    $summary
}

function Move-OldFile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$ArchivePath,

        [int]$Days = 365
    )

    $limit = (Get-Date).AddDays(-$Days)
    $oldFiles = Get-ChildItem -Path $Path -Recurse -File |
        Where-Object { $_.LastWriteTime -lt $limit }

    foreach ($file in $oldFiles) {
        $destDir = Join-Path $ArchivePath "$($file.LastWriteTime.Year)\$($file.Directory.Name)"
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        Move-Item -LiteralPath $file.FullName -Destination $destDir
    }

    "対象: $(@($oldFiles).Count) 件（$($limit.ToString('yyyy/MM/dd')) より前に更新されたファイル）"
}
