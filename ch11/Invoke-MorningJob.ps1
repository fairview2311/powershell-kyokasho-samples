# 毎朝の処理: パソコンの点検とログの確認を行い、結果をメールと Teams に通知する
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

$logDir = Join-Path $PSScriptRoot 'logs'
New-Item -ItemType Directory -Path $logDir -Force | Out-Null
Start-Transcript -Path (Join-Path $logDir ('morning-{0:yyyyMMdd}.txt' -f (Get-Date))) -Append | Out-Null

try {
    Import-Module (Join-Path $PSScriptRoot 'MidoriTools') -Force
    $settings = Import-PowerShellDataFile -Path (Join-Path $PSScriptRoot 'morning-settings.psd1')

    # 1. パソコンを点検する
    $health = Test-PcHealth -ComputerName $settings.ComputerName -MinFreePercent $settings.MinFreePercent

    # 2. 今日のログから、注意（WARN）とエラー（ERROR）の行を取り出す
    $logPath = Join-Path $logDir ('MidoriTools-{0:yyyyMMdd}.log' -f (Get-Date))
    $alerts = @()
    if (Test-Path -Path $logPath) {
        $alerts = @(Get-Content -Path $logPath -Encoding UTF8 | Where-Object { $_ -match '\[(WARN|ERROR)\]' })
    }

    # 3. 通知の本文を作る
    $lines = @("みどり文具 毎朝の点検（{0:yyyy/MM/dd HH:mm}）" -f (Get-Date), '')
    foreach ($h in $health) {
        $lines += "{0}: C ドライブの空き {1} GB（{2}%）、7日間のエラー {3} 件" -f $h.コンピューター, $h.空きGB, $h.空き率, $h.エラー件数
    }
    $lines += ''
    if ($alerts) {
        $lines += "ログの注意・エラー: $($alerts.Count) 件"
        $lines += $alerts
    }
    else {
        $lines += 'ログの注意・エラー: なし'
    }
    $text = $lines -join "`n"
    $subject = if ($alerts) { '【要確認】毎朝の点検' } else { '毎朝の点検' }

    # 4. アプリとして Graph に接続し、メールを送る
    $app = @{
        ClientId              = $settings.ClientId
        TenantId              = $settings.TenantId
        CertificateThumbprint = $settings.CertificateThumbprint
    }
    Connect-MgGraph @app -NoWelcome
    $mail = @{
        Message         = @{
            Subject      = $subject
            Body         = @{ ContentType = 'Text'; Content = $text }
            ToRecipients = @(@{ EmailAddress = @{ Address = $settings.MailTo } })
        }
        SaveToSentItems = $false
    }
    Send-MgUserMail -UserId $settings.MailFrom -BodyParameter $mail
    Disconnect-MgGraph | Out-Null

    # 5. Teams に投稿する
    $card = @{
        type        = 'message'
        attachments = @(@{
            contentType = 'application/vnd.microsoft.card.adaptive'
            content     = @{
                '$schema' = 'http://adaptivecards.io/schemas/adaptive-card.json'
                type      = 'AdaptiveCard'
                version   = '1.4'
                body      = @(@{ type = 'TextBlock'; text = $text; wrap = $true })
            }
        })
    }
    $json = ConvertTo-Json -InputObject $card -Depth 10
    Invoke-RestMethod -Method Post -Uri $settings.TeamsWebhookUrl -ContentType 'application/json; charset=utf-8' -Body ([Text.Encoding]::UTF8.GetBytes($json)) | Out-Null

    Write-MidoriLog -Message "毎朝の処理が終わりました（注意・エラー $($alerts.Count) 件）"
}
catch {
    Write-MidoriLog -Level ERROR -Message "毎朝の処理が止まりました: $($_.Exception.Message.Trim())"
    throw
}
finally {
    Stop-Transcript | Out-Null
}
