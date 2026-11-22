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

function Get-InstalledSoftware {
    [CmdletBinding()]
    param(
        [string]$Name = '*'
    )

    $paths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    Get-ItemProperty -Path $paths -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like $Name } |
        Select-Object -Property @{ Name = '名前'; Expression = { $_.DisplayName } },
            @{ Name = 'バージョン'; Expression = { $_.DisplayVersion } },
            @{ Name = '発行元'; Expression = { $_.Publisher } } |
        Sort-Object -Property 名前
}

function Test-PcHealth {
    [CmdletBinding()]
    param(
        [string[]]$ComputerName,

        [pscredential]$Credential,

        [int]$MinFreePercent = 15,

        [int]$Days = 7
    )

    $check = {
        param($Days)
        $os     = Get-CimInstance -ClassName Win32_OperatingSystem
        $disk   = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"
        $errors = Get-WinEvent -FilterHashtable @{ LogName = 'System'; Level = 2; StartTime = (Get-Date).AddDays(-$Days) } -ErrorAction SilentlyContinue
        [pscustomobject]@{
            コンピューター = $env:COMPUTERNAME
            OS             = $os.Caption
            起動日時       = $os.LastBootUpTime
            空きGB         = [math]::Round($disk.FreeSpace / 1GB, 1)
            空き率         = [int]($disk.FreeSpace / $disk.Size * 100)
            エラー件数     = @($errors).Count
        }
    }

    if ($ComputerName) {
        $params = @{ ComputerName = $ComputerName; ScriptBlock = $check; ArgumentList = $Days }
        if ($Credential) {
            $params.Credential = $Credential
        }
        $results = Invoke-Command @params -ErrorAction SilentlyContinue -ErrorVariable remoteErrors |
            Select-Object -Property * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName
        foreach ($e in $remoteErrors) {
            Write-MidoriLog -Level ERROR -Message "点検できません: $($e.TargetObject)（$($e.Exception.Message.Trim())）"
        }
    } else {
        $results = & $check $Days
    }

    foreach ($r in $results) {
        if ($r.空き率 -lt $MinFreePercent) {
            Write-MidoriLog -Level WARN -Message "ディスクの空きが少ない: $($r.コンピューター)（C: $($r.空きGB) GB、$($r.空き率)%）"
        }
        $r
    }
}

function New-MidoriPassword {
    [CmdletBinding()]
    param()

    $sets = 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'abcdefghijkmnopqrstuvwxyz', '23456789', '#%+-=?'
    $chars = foreach ($set in $sets) {
        Get-Random -InputObject $set.ToCharArray() -Count 3
    }
    -join (Get-Random -InputObject $chars -Count $chars.Count)
}

function Sync-ADUsersFromCsv {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$OrgUnit,

        [string]$PasswordPath = (Join-Path (Split-Path $PSScriptRoot) 'output\initial-passwords.csv')
    )

    Import-Module ActiveDirectory -ErrorAction Stop
    $domain = Get-ADDomain
    $baseOU = "OU=$OrgUnit,$($domain.DistinguishedName)"
    $rows = Import-Csv -Path $Path -Encoding (Get-MidoriEncoding).Read
    $passwords = @()

    foreach ($row in $rows) {
        $name = $row.ユーザー名
        $result = 'OK'
        try {
            switch ($row.区分) {
                '入社' {
                    if (Get-ADUser -Filter "SamAccountName -eq '$name'") {
                        $result = '作成済み'
                        Write-MidoriLog -Level WARN -Message "入社: $name は既にあるので飛ばしました"
                    }
                    elseif ($PSCmdlet.ShouldProcess($name, "入社: $($row.部署) に作成")) {
                        $fullName = "$($row.姓) $($row.名)"
                        $password = New-MidoriPassword
                        $params = @{
                            Name                  = $fullName
                            DisplayName           = $fullName
                            Surname               = $row.姓
                            GivenName             = $row.名
                            SamAccountName        = $name
                            UserPrincipalName     = "$name@$($domain.DNSRoot)"
                            Department            = $row.部署
                            Path                  = "OU=$($row.部署),$baseOU"
                            AccountPassword       = ConvertTo-SecureString -String $password -AsPlainText -Force
                            ChangePasswordAtLogon = $true
                            Enabled               = $true
                        }
                        Get-ADOrganizationalUnit -Identity $params.Path -ErrorAction Stop | Out-Null
                        New-ADUser @params -ErrorAction Stop
                        Add-ADGroupMember -Identity "$OrgUnit-$($row.部署)" -Members $name -ErrorAction Stop
                        $passwords += [pscustomobject]@{ ユーザー名 = $name; 氏名 = $fullName; 初期パスワード = $password }
                        Write-MidoriLog -Message "入社: $name を作成しました（$($row.部署)）"
                    }
                }
                '異動' {
                    $user = Get-ADUser -Identity $name -Properties Department -ErrorAction Stop
                    if ($user.Department -eq $row.部署) {
                        $result = '変更なし'
                    }
                    elseif ($PSCmdlet.ShouldProcess($name, "異動: $($user.Department) から $($row.部署) へ")) {
                        Get-ADOrganizationalUnit -Identity "OU=$($row.部署),$baseOU" -ErrorAction Stop | Out-Null
                        Add-ADGroupMember -Identity "$OrgUnit-$($row.部署)" -Members $name -ErrorAction Stop
                        Remove-ADGroupMember -Identity "$OrgUnit-$($user.Department)" -Members $name -Confirm:$false -ErrorAction Stop
                        Set-ADUser -Identity $name -Department $row.部署 -ErrorAction Stop
                        Move-ADObject -Identity $user.DistinguishedName -TargetPath "OU=$($row.部署),$baseOU" -ErrorAction Stop
                        Write-MidoriLog -Message "異動: $name を $($user.Department) から $($row.部署) へ移しました"
                    }
                }
                '退職' {
                    $user = Get-ADUser -Identity $name -Properties Department -ErrorAction Stop
                    if (-not $user.Enabled) {
                        $result = '変更なし'
                    }
                    elseif ($PSCmdlet.ShouldProcess($name, '退職: 無効にして退職者へ移動')) {
                        Disable-ADAccount -Identity $name -ErrorAction Stop
                        Set-ADUser -Identity $name -Description ('退職 {0:yyyy/MM/dd}' -f (Get-Date)) -ErrorAction Stop
                        Remove-ADGroupMember -Identity "$OrgUnit-$($user.Department)" -Members $name -Confirm:$false -ErrorAction Stop
                        Move-ADObject -Identity $user.DistinguishedName -TargetPath "OU=退職者,$baseOU" -ErrorAction Stop
                        Write-MidoriLog -Message "退職: $name を無効にしました"
                    }
                }
                default {
                    $result = '区分が不明'
                    Write-MidoriLog -Level WARN -Message "区分が分からないので飛ばしました: $name（$($row.区分)）"
                }
            }
        }
        catch {
            $result = 'エラー'
            Write-MidoriLog -Level ERROR -Message "処理できません: $name（$($_.Exception.Message.Trim())）"
        }
        [pscustomobject]@{ 区分 = $row.区分; ユーザー名 = $name; 部署 = $row.部署; 結果 = $result }
    }

    if ($passwords) {
        New-Item -ItemType Directory -Path (Split-Path $PasswordPath) -Force | Out-Null
        $passwords | Export-Csv -Path $PasswordPath -NoTypeInformation -Encoding (Get-MidoriEncoding).Write
        Write-MidoriLog -Message "初期パスワードを書き出しました: $PasswordPath（$($passwords.Count) 人）"
    }
}

function Sync-M365Users {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [string]$SkuPartNumber = 'SPB',

        [string]$PasswordPath = (Join-Path (Split-Path $PSScriptRoot) 'output\m365-initial-passwords.csv')
    )

    $domain = ((Get-MgOrganization).VerifiedDomains | Where-Object IsDefault).Name
    $sku = Get-MgSubscribedSku | Where-Object SkuPartNumber -eq $SkuPartNumber
    if (-not $sku) {
        throw "ライセンスが見つかりません: $SkuPartNumber"
    }
    $rows = Import-Csv -Path $Path -Encoding (Get-MidoriEncoding).Read
    $passwords = @()

    foreach ($row in $rows) {
        $upn = "$($row.ユーザー名)@$domain"
        $result = 'OK'
        try {
            $user = Get-MgUser -Filter "userPrincipalName eq '$upn'" -Property Id, Department, AccountEnabled
            switch ($row.区分) {
                '入社' {
                    if ($user) {
                        $result = '作成済み'
                        Write-MidoriLog -Level WARN -Message "M365 入社: $upn は既にあるので飛ばしました"
                    }
                    elseif ($PSCmdlet.ShouldProcess($upn, "入社: 作成してライセンスを割り当て")) {
                        $password = New-MidoriPassword
                        $params = @{
                            DisplayName       = "$($row.姓) $($row.名)"
                            Surname           = $row.姓
                            GivenName         = $row.名
                            UserPrincipalName = $upn
                            MailNickname      = $row.ユーザー名
                            Department        = $row.部署
                            UsageLocation     = 'JP'
                            AccountEnabled    = $true
                            PasswordProfile   = @{ Password = $password; ForceChangePasswordNextSignIn = $true }
                        }
                        $new = New-MgUser @params -ErrorAction Stop
                        Set-MgUserLicense -UserId $new.Id -AddLicenses @(@{ SkuId = $sku.SkuId }) -RemoveLicenses @() -ErrorAction Stop | Out-Null
                        $passwords += [pscustomobject]@{ ユーザー名 = $upn; 氏名 = $params.DisplayName; 初期パスワード = $password }
                        Write-MidoriLog -Message "M365 入社: $upn を作成し、$SkuPartNumber を割り当てました"
                    }
                }
                '異動' {
                    if (-not $user) {
                        throw "ユーザーが見つかりません: $upn"
                    }
                    if ($user.Department -eq $row.部署) {
                        $result = '変更なし'
                    }
                    elseif ($PSCmdlet.ShouldProcess($upn, "異動: $($user.Department) から $($row.部署) へ")) {
                        Update-MgUser -UserId $user.Id -Department $row.部署 -ErrorAction Stop
                        Write-MidoriLog -Message "M365 異動: $upn の部署を $($row.部署) にしました"
                    }
                }
                '退職' {
                    if (-not $user) {
                        throw "ユーザーが見つかりません: $upn"
                    }
                    if (-not $user.AccountEnabled) {
                        $result = '変更なし'
                    }
                    elseif ($PSCmdlet.ShouldProcess($upn, '退職: サインインを停止')) {
                        Update-MgUser -UserId $user.Id -AccountEnabled:$false -ErrorAction Stop
                        Revoke-MgUserSignInSession -UserId $user.Id -ErrorAction Stop | Out-Null
                        Write-MidoriLog -Message "M365 退職: $upn のサインインを停止しました"
                    }
                }
                default {
                    $result = '区分が不明'
                    Write-MidoriLog -Level WARN -Message "区分が分からないので飛ばしました: $upn（$($row.区分)）"
                }
            }
        }
        catch {
            $result = 'エラー'
            Write-MidoriLog -Level ERROR -Message "M365 処理できません: $upn（$($_.Exception.Message.Trim())）"
        }
        [pscustomobject]@{ 区分 = $row.区分; ユーザー名 = $upn; 部署 = $row.部署; 結果 = $result }
    }

    if ($passwords) {
        New-Item -ItemType Directory -Path (Split-Path $PasswordPath) -Force | Out-Null
        $passwords | Export-Csv -Path $PasswordPath -NoTypeInformation -Encoding (Get-MidoriEncoding).Write
        Write-MidoriLog -Message "初期パスワードを書き出しました: $PasswordPath（$($passwords.Count) 人）"
    }
}
