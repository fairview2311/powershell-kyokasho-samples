# 部署別の集計の CSV を、Excel のファイル（.xlsx）にする
$CsvPath  = Join-Path $PSScriptRoot 'output\部署別売上-202610.csv'
$XlsxPath = Join-Path $PSScriptRoot 'output\部署別売上-202610.xlsx'

if ($PSVersionTable.PSVersion.Major -ge 7) {
    $encoding = 'utf8BOM'
} else {
    $encoding = 'UTF8'
}
$rows = Import-Csv -Path $CsvPath -Encoding $encoding

$excel = New-Object -ComObject Excel.Application
$excel.DisplayAlerts = $false
try {
    $book  = $excel.Workbooks.Add()
    $sheet = $book.Worksheets.Item(1)
    $sheet.Name = '部署別売上'

    $sheet.Cells.Item(1, 1).Value2 = '部署'
    $sheet.Cells.Item(1, 2).Value2 = '件数'
    $sheet.Cells.Item(1, 3).Value2 = '合計金額'

    $r = 2
    foreach ($row in $rows) {
        $sheet.Cells.Item($r, 1).Value2 = $row.部署
        $sheet.Cells.Item($r, 2).Value2 = [int]$row.件数
        $sheet.Cells.Item($r, 3).Value2 = [int]$row.合計金額
        $r++
    }

    $sheet.Range("C2:C$($r - 1)").NumberFormat = '#,##0'
    $sheet.Columns.AutoFit() | Out-Null
    $book.SaveAs($XlsxPath, 51)
    $book.Close($false)
}
finally {
    $excel.Quit()
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
"書き出しました: $XlsxPath"
