# みどり文具の作業箱（モジュール）

function Get-MidoriEncoding {
    # 5.1 と 7 で名前が違う文字コードを、読み込み用と書き出し用の組で返す
    if ($PSVersionTable.PSVersion.Major -ge 7) {
        [pscustomobject]@{ Read = 'Ansi'; Write = 'utf8BOM' }
    } else {
        [pscustomobject]@{ Read = 'Default'; Write = 'UTF8' }
    }
}

function Write-MidoriLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet('INFO', 'WARN', 'ERROR')]
        [string]$Level = 'INFO'
    )

    $logDir  = Join-Path (Split-Path $PSScriptRoot) 'logs'
    $logPath = Join-Path $logDir ('MidoriTools-{0:yyyyMMdd}.log' -f (Get-Date))
    $line    = '{0:yyyy/MM/dd HH:mm:ss} [{1}] {2}' -f (Get-Date), $Level, $Message

    New-Item -ItemType Directory -Path $logDir -Force -WhatIf:$false | Out-Null
    Add-Content -Path $logPath -Value $line -Encoding (Get-MidoriEncoding).Write -WhatIf:$false
    Write-Verbose $line
}

function Get-SalesSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [string]$OutputPath
    )

    $encoding = Get-MidoriEncoding
    try {
        $rows = Import-Csv -Path $Path -Encoding $encoding.Read -ErrorAction Stop
    }
    catch {
        Write-MidoriLog -Level ERROR -Message "売上の CSV を読み込めません: $Path（$($_.Exception.Message.Trim())）"
        throw
    }

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

    Write-MidoriLog -Message "売上を集計しました: $Path（$(@($summary).Count) 部署）"
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

    $failed = 0
    foreach ($file in $oldFiles) {
        $destDir = Join-Path $ArchivePath "$($file.LastWriteTime.Year)\$($file.Directory.Name)"
        try {
            New-Item -ItemType Directory -Path $destDir -Force -ErrorAction Stop | Out-Null
            Move-Item -LiteralPath $file.FullName -Destination $destDir -ErrorAction Stop
        }
        catch {
            $failed++
            Write-MidoriLog -Level ERROR -Message "移せません: $($file.FullName)（$($_.Exception.Message.Trim())）"
        }
    }

    $message = "対象: $(@($oldFiles).Count) 件、失敗: $failed 件（$($limit.ToString('yyyy/MM/dd')) より前に更新されたファイル）"
    if (-not $WhatIfPreference) {
        $level = 'INFO'
        if ($failed -gt 0) {
            $level = 'WARN'
        }
        Write-MidoriLog -Level $level -Message "古いファイルを処理しました: $Path　$message"
    }
    $message
}
