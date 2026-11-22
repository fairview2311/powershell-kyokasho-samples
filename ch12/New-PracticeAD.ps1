# 第9章の練習用の OU・グループ・ユーザーを作る（何度実行しても、同じ状態に作り直す）
Import-Module ActiveDirectory
Import-Module (Join-Path $PSScriptRoot 'MidoriTools') -Force

$top = '練習'
$domainDN = (Get-ADDomain).DistinguishedName
$topDN = "OU=$top,$domainDN"

if (Get-ADOrganizationalUnit -Filter "Name -eq '$top'" -SearchBase $domainDN -SearchScope OneLevel) {
    Remove-ADOrganizationalUnit -Identity $topDN -Recursive -Confirm:$false
}

New-ADOrganizationalUnit -Name $top -Path $domainDN -ProtectedFromAccidentalDeletion $false
foreach ($ou in '総務部', '営業部', '経理部', '退職者') {
    New-ADOrganizationalUnit -Name $ou -Path $topDN -ProtectedFromAccidentalDeletion $false
}
foreach ($dept in '総務部', '営業部', '経理部') {
    New-ADGroup -Name "$top-$dept" -GroupScope Global -GroupCategory Security -Path $topDN
}

$users = @(
    @{ Sam = 'suzuki.ichiro'; Sei = '鈴木'; Mei = '一郎'; Dept = '営業部' }
    @{ Sam = 'tanaka.jiro';   Sei = '田中'; Mei = '次郎'; Dept = '総務部' }
    @{ Sam = 'kato.megumi';   Sei = '加藤'; Mei = '恵';   Dept = '経理部' }
)
foreach ($u in $users) {
    $fullName = "$($u.Sei) $($u.Mei)"
    New-ADUser -Name $fullName -DisplayName $fullName -Surname $u.Sei -GivenName $u.Mei `
        -SamAccountName $u.Sam -Department $u.Dept -Path "OU=$($u.Dept),$topDN" `
        -AccountPassword (ConvertTo-SecureString -String (New-MidoriPassword) -AsPlainText -Force) -Enabled $true
    Add-ADGroupMember -Identity "$top-$($u.Dept)" -Members $u.Sam
}

Get-ADUser -Filter * -SearchBase $topDN -Properties Department |
    Select-Object -Property Name, SamAccountName, Department
