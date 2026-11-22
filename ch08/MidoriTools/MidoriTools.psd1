@{
    RootModule           = 'MidoriTools.psm1'
    ModuleVersion        = '1.2.0'
    Description          = 'みどり文具の作業箱'
    PowerShellVersion    = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')
    FunctionsToExport    = @('Get-SalesSummary', 'Move-OldFile', 'Write-MidoriLog', 'Test-PcHealth', 'Get-InstalledSoftware')
}
