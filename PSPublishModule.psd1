﻿@{
    AliasesToExport        = @('New-PrepareModule', 'Build-Module', 'Invoke-ModuleBuilder')
    Author                 = 'Przemyslaw Klys'
    CmdletsToExport        = @()
    CompanyName            = 'Evotec'
    CompatiblePSEditions   = @('Desktop', 'Core')
    Copyright              = '(c) 2011 - 2023 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description            = 'Simple project allowing preparing, managing, building and publishing modules to PowerShellGallery'
    DotNetFrameworkVersion = '4.5.2'
    FunctionsToExport      = @('Convert-CommandsToList', 'Get-MissingFunctions', 'Initialize-PortableModule', 'Initialize-PortableScript', 'Initialize-ProjectManager', 'Invoke-ModuleBuild', 'New-ConfigurationArtefact', 'New-ConfigurationBuild', 'New-ConfigurationCommand', 'New-ConfigurationDocumentation', 'New-ConfigurationExecute', 'New-ConfigurationFormat', 'New-ConfigurationImportModule', 'New-ConfigurationInformation', 'New-ConfigurationManifest', 'New-ConfigurationModule', 'New-ConfigurationModuleSkip', 'New-ConfigurationPublish', 'New-ConfigurationTest', 'Register-Certificate', 'Remove-Comments', 'Send-GitHubRelease', 'Test-BasicModule', 'Test-ScriptFile', 'Test-ScriptModule')
    GUID                   = 'eb76426a-1992-40a5-82cd-6480f883ef4d'
    ModuleVersion          = '2.0.3'
    PowerShellVersion      = '5.1'
    PrivateData            = @{
        PSData = @{
            Tags                       = @('Windows', 'MacOS', 'Linux', 'Build', 'Module')
            IconUri                    = 'https://evotec.xyz/wp-content/uploads/2019/02/PSPublishModule.png'
            ProjectUri                 = 'https://github.com/EvotecIT/PSPublishModule'
            ExternalModuleDependencies = @('PKI', 'Microsoft.PowerShell.Utility', 'Microsoft.PowerShell.Archive', 'Microsoft.PowerShell.Management', 'Microsoft.PowerShell.Security')
        }
    }
    RequiredModules        = @(@{
            ModuleName    = 'platyPS'
            ModuleVersion = '0.14.2'
            Guid          = '0bdcabef-a4b7-4a6d-bf7e-d879817ebbff'
        }, @{
            ModuleName    = 'powershellget'
            ModuleVersion = '2.2.5'
            Guid          = '1d73a601-4a6c-43c5-ba3f-619b18bbb404'
        }, @{
            ModuleName    = 'PSScriptAnalyzer'
            ModuleVersion = '1.21.0'
            Guid          = 'd6245802-193d-4068-a631-8863a4342a18'
        }, @{
            ModuleName    = 'Pester'
            ModuleVersion = '5.5.0'
            Guid          = 'a699dea5-2c73-4616-a270-1f7abb777e71'
        }, 'PKI', 'Microsoft.PowerShell.Utility', 'Microsoft.PowerShell.Archive', 'Microsoft.PowerShell.Management', 'Microsoft.PowerShell.Security')
    RootModule             = 'PSPublishModule.psm1'
}