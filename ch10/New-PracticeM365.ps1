# 第10章の練習用のユーザーを Microsoft 365 に作る（何度実行しても、同じ状態に作り直す）
Import-Module (Join-Path $PSScriptRoot 'MidoriTools') -Force

$domain = ((Get-MgOrganization).VerifiedDomains | Where-Object IsDefault).Name
$names = 'suzuki.ichiro', 'tanaka.jiro', 'kato.megumi', 'sato.hanako', 'takahashi.ken', 'ito.yui'
foreach ($name in $names) {
    $old = Get-MgUser -Filter "userPrincipalName eq '$name@$domain'"
    if ($old) {
        Remove-MgUser -UserId $old.Id
    }
}

$users = @(
    @{ Name = 'suzuki.ichiro'; Sei = '鈴木'; Mei = '一郎'; Dept = '営業部' }
    @{ Name = 'tanaka.jiro';   Sei = '田中'; Mei = '次郎'; Dept = '総務部' }
    @{ Name = 'kato.megumi';   Sei = '加藤'; Mei = '恵';   Dept = '経理部' }
)
foreach ($u in $users) {
    $params = @{
        DisplayName       = "$($u.Sei) $($u.Mei)"
        Surname           = $u.Sei
        GivenName         = $u.Mei
        UserPrincipalName = "$($u.Name)@$domain"
        MailNickname      = $u.Name
        Department        = $u.Dept
        UsageLocation     = 'JP'
        AccountEnabled    = $true
        PasswordProfile   = @{ Password = New-MidoriPassword; ForceChangePasswordNextSignIn = $true }
    }
    $new = New-MgUser @params
    [pscustomobject]@{ 表示名 = $new.DisplayName; ユーザー名 = $new.UserPrincipalName; 部署 = $u.Dept }
}
