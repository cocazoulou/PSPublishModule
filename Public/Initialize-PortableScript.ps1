﻿function Initialize-PortableScript {
    [cmdletBinding()]
    param(
        [string] $FilePath,
        [string] $OutputPath,
        [Array] $ApprovedModules
    )
    $Output = Get-MissingFunctions -FilePath $FilePath -SummaryWithCommands -ApprovedModules $ApprovedModules
    $Script = Get-Content -LiteralPath $FilePath -Encoding UTF8
    $FinalScript = @(
        $Output.Functions
        $Script
    )
    $FinalScript | Set-Content -LiteralPath $OutputPath
    $Output
}