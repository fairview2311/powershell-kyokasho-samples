# 作業箱のスクリプトとモジュールを、5.1 と 7 の両方で点検する
param(
    [string]$Path = $PSScriptRoot
)

# 1. 点検するファイル（練習用・バックアップ・前任者のフォルダーと、このスクリプトは除く）
$files = Get-ChildItem -Path $Path -Recurse -File -Include '*.ps1', '*.psm1', '*.psd1' |
    Where-Object { $_.FullName -notmatch '\\(practice|backup|logs|old)\\' -and $_.FullName -ne $PSCommandPath }

# 2. 古い書き方（見つけたら書き換える）
$patterns = [ordered]@{
    '\bGet-WmiObject\b'         = 'Get-WmiObject は、7 ではバックグラウンドで 5.1 を起動して動く。Get-CimInstance に書き換える'
    '\bwmic\b'                  = 'WMIC は Windows から削除された。Get-CimInstance に書き換える'
    '\b(cscript|wscript)\b'     = 'VBScript は将来削除される。PowerShell に書き換える'
    '-Encoding\s+Default\b'     = 'Default は、5.1 では Shift-JIS、7 では UTF-8。Get-MidoriEncoding を使う'
}

$problems = @(foreach ($file in $files) {
    $name = $file.FullName.Substring($Path.Length + 1)

    # 3. BOM が無いと、5.1 は日本語を読み違える
    $bytes = [IO.File]::ReadAllBytes($file.FullName)
    if (-not ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)) {
        [pscustomobject]@{ ファイル = $name; 行 = ''; 内容 = 'BOM 付きの UTF-8 で保存し直す' }
    }

    foreach ($p in $patterns.Keys) {
        foreach ($m in (Select-String -Path $file.FullName -Pattern $p)) {
            [pscustomobject]@{ ファイル = $name; 行 = $m.LineNumber; 内容 = $patterns[$p] }
        }
    }
})

# 4. 5.1 と 7 のそれぞれで、構文とモジュールの読み込みを確かめる
$check = {
    param([string[]]$Paths, [string]$ModulePath)
    foreach ($f in $Paths) {
        $errors = $null
        [void][System.Management.Automation.Language.Parser]::ParseFile($f, [ref]$null, [ref]$errors)
        foreach ($e in $errors) {
            "{0}`t{1}`t構文のエラー: {2}" -f $f, $e.Extent.StartLineNumber, $e.Message
        }
    }
    try {
        Import-Module $ModulePath -Force -ErrorAction Stop
        "`t`tモジュールの関数: {0} 個" -f @(Get-Command -Module MidoriTools).Count
    } catch {
        "`t`tモジュールを読み込めない: {0}" -f $_.Exception.Message
    }
}

$shells = [ordered]@{
    '5.1' = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    '7'   = Join-Path $env:ProgramFiles 'PowerShell\7\pwsh.exe'
}
$counts = @{}
foreach ($v in $shells.Keys) {
    $lines = & $shells[$v] -NoProfile -Command $check -args $files.FullName, (Join-Path $Path 'MidoriTools')
    foreach ($line in $lines) {
        $f, $n, $text = $line -split "`t"
        if ($text -like 'モジュールの関数*') {
            $counts[$v] = $text
            continue
        }
        $problems += [pscustomobject]@{ ファイル = $f.Substring($Path.Length + 1); 行 = $n; 内容 = "（${v}）$text" }
    }
}

# 5. 結果
"{0} 個のファイルを点検しました（5.1 の{1}、7 の{2}）" -f @($files).Count, $counts['5.1'], $counts['7']
if ($problems) {
    $problems | Format-Table -AutoSize -Wrap
} else {
    '問題は見つかりませんでした'
}
