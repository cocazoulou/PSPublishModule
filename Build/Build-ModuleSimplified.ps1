﻿Clear-Host

# please notice I may be using PSM1 here, as the module may not be built or PSD1 may be broken
# since PSD1 is not required for proper rebuilding, we use PSM1 for this module only
# most modules should be run via PSD1 or by it's name (which in the background uses PD1)

Import-Module "$PSScriptRoot\..\PSPublishModule.psd1" -Force

Build-Module -ModuleName 'PSPublishModule' {
    # Usual defaults as per standard module
    $Manifest = [ordered] @{
        ModuleVersion          = '2.0.X'
        #PreReleaseTag          = 'Preview5'
        CompatiblePSEditions   = @('Desktop', 'Core')
        GUID                   = 'eb76426a-1992-40a5-82cd-6480f883ef4d'
        Author                 = 'Przemyslaw Klys'
        CompanyName            = 'Evotec'
        Copyright              = "(c) 2011 - $((Get-Date).Year) Przemyslaw Klys @ Evotec. All rights reserved."
        Description            = 'Simple project allowing preparing, managing, building and publishing modules to PowerShellGallery'
        PowerShellVersion      = '5.1'
        Tags                   = @('Windows', 'MacOS', 'Linux', 'Build', 'Module')
        IconUri                = 'https://evotec.xyz/wp-content/uploads/2019/02/PSPublishModule.png'
        ProjectUri             = 'https://github.com/EvotecIT/PSPublishModule'
        DotNetFrameworkVersion = '4.5.2'
    }
    New-ConfigurationManifest @Manifest

    # Add standard module dependencies (directly, but can be used with loop as well)
    New-ConfigurationModule -Type RequiredModule -Name 'platyPS' -Guid 'Auto' -Version 'Latest'
    New-ConfigurationModule -Type RequiredModule -Name 'powershellget' -Guid 'Auto' -Version 'Latest'
    New-ConfigurationModule -Type RequiredModule -Name 'PSScriptAnalyzer' -Guid 'Auto' -Version 'Latest'
    New-ConfigurationModule -Type RequiredModule -Name 'Pester' -Version Auto -Guid Auto

    # Add external module dependencies, using loop for simplicity
    foreach ($Module in @('PKI', 'Microsoft.PowerShell.Utility', 'Microsoft.PowerShell.Archive', 'Microsoft.PowerShell.Management', 'Microsoft.PowerShell.Security')) {
        New-ConfigurationModule -Type ExternalModule -Name $Module
    }

    # Add approved modules, that can be used as a dependency, but only when specific function from those modules is used
    # And on that time only that function and dependant functions will be copied over
    # Keep in mind it has it's limits when "copying" functions such as it should not depend on DLLs or other external files
    New-ConfigurationModule -Type ApprovedModule -Name 'PSSharedGoods', 'PSWriteColor', 'Connectimo', 'PSUnifi', 'PSWebToolbox', 'PSMyPassword'

    #New-ConfigurationModuleSkip -IgnoreFunctionName 'Invoke-Formatter', 'Find-Module' -IgnoreModuleName 'platyPS'

    $ConfigurationFormat = [ordered] @{
        RemoveComments                              = $false

        PlaceOpenBraceEnable                        = $true
        PlaceOpenBraceOnSameLine                    = $true
        PlaceOpenBraceNewLineAfter                  = $true
        PlaceOpenBraceIgnoreOneLineBlock            = $false

        PlaceCloseBraceEnable                       = $true
        PlaceCloseBraceNewLineAfter                 = $true
        PlaceCloseBraceIgnoreOneLineBlock           = $false
        PlaceCloseBraceNoEmptyLineBefore            = $true

        UseConsistentIndentationEnable              = $true
        UseConsistentIndentationKind                = 'space'
        UseConsistentIndentationPipelineIndentation = 'IncreaseIndentationAfterEveryPipeline'
        UseConsistentIndentationIndentationSize     = 4

        UseConsistentWhitespaceEnable               = $true
        UseConsistentWhitespaceCheckInnerBrace      = $true
        UseConsistentWhitespaceCheckOpenBrace       = $true
        UseConsistentWhitespaceCheckOpenParen       = $true
        UseConsistentWhitespaceCheckOperator        = $true
        UseConsistentWhitespaceCheckPipe            = $true
        UseConsistentWhitespaceCheckSeparator       = $true

        AlignAssignmentStatementEnable              = $true
        AlignAssignmentStatementCheckHashtable      = $true

        UseCorrectCasingEnable                      = $true
    }
    # format PSD1 and PSM1 files when merging into a single file
    # enable formatting is not required as Configuration is provided
    New-ConfigurationFormat -ApplyTo 'OnMergePSM1', 'OnMergePSD1' -Sort None @ConfigurationFormat
    # format PSD1 and PSM1 files within the module
    # enable formatting is required to make sure that formatting is applied (with default settings)
    New-ConfigurationFormat -ApplyTo 'DefaultPSD1', 'DefaultPSM1' -EnableFormatting -Sort None
    # when creating PSD1 use special style without comments and with only required parameters
    New-ConfigurationFormat -ApplyTo 'DefaultPSD1', 'OnMergePSD1' -PSD1Style 'Minimal'

    # configuration for documentation, at the same time it enables documentation processing
    New-ConfigurationDocumentation -Enable:$true -StartClean -UpdateWhenNew -PathReadme 'Docs\Readme.md' -Path 'Docs'

    New-ConfigurationImportModule -ImportSelf -ImportRequiredModules

    $newConfigurationBuildSplat = @{
        Enable                         = $true
        SignModule                     = $true
        DeleteTargetModuleBeforeBuild  = $true
        MergeModuleOnBuild             = $true
        CertificateThumbprint          = '483292C9E317AA13B07BB7A96AE9D1A5ED9E7703'
        #CertificatePFXBase64           = $BasePfx
        #CertificatePFXPassword         = "zGT"
        DoNotAttemptToFixRelativePaths = $false
    }

    New-ConfigurationBuild @newConfigurationBuildSplat

    New-ConfigurationArtefact -Type Unpacked -Enable -Path "$PSScriptRoot\..\Artefacts\Unpacked" -RequiredModulesPath "$PSScriptRoot\..\Artefacts\Unpacked\Modules" -AddRequiredModules -CopyFiles @{
        "Examples\Step01.CreateModuleProject.ps1" = "Examples\Step01.CreateModuleProject.ps1"
        "Examples\Step02.BuildModuleOver.ps1"     = "Examples\Step02.BuildModuleOver.ps1"
    } -CopyFilesRelative -ArtefactName "PSPublishModule.<TagModuleVersionWithPreRelease>.zip"

    New-ConfigurationArtefact -Type Packed -Enable -Path "$PSScriptRoot\..\Artefacts\PackedWithModules" -IncludeTagName -ID 'ToGitHub' -AddRequiredModules -CopyFiles @{
        "Examples\Step01.CreateModuleProject.ps1" = "Examples\Step01.CreateModuleProject.ps1"
        "Examples\Step02.BuildModuleOver.ps1"     = "Examples\Step02.BuildModuleOver.ps1"
    } -CopyFilesRelative -ArtefactName "PSPublishModule.<TagModuleVersionWithPreRelease>-FullPackage.zip"

    New-ConfigurationArtefact -Type Packed -Enable -Path "$PSScriptRoot\..\Artefacts\Packed" -IncludeTagName -ID 'ToGitHub' -ArtefactName "PSPublishModule.<TagModuleVersionWithPreRelease>.zip"

    New-ConfigurationTest -TestsPath "$PSScriptRoot\..\Tests" -Enable

    # global options for publishing to github/psgallery
    # you can use FilePath where APIKey are saved in clear text or use APIKey directly
    #New-ConfigurationPublish -Type PowerShellGallery -FilePath 'C:\Support\Important\PowerShellGalleryAPI.txt' -Enabled:$true
    #New-ConfigurationPublish -Type GitHub -FilePath 'C:\Support\Important\GitHubAPI.txt' -UserName 'EvotecIT' -Enabled:$true -ID 'ToGitHub' -OverwriteTagName '<TagModuleVersionWithPreRelease>'


    ### FOR TESTING PURPOSES ONLY ###
    ### SHOWING HHOW THINGS WORK HERE ###

    #New-ConfigurationArtefact -Type Packed -Enable -Path "$PSScriptRoot\..\Artefacts\Packed2" -IncludeTagName -ID 'Packed2'
    #New-ConfigurationArtefact -Type Packed -Enable -Path "$PSScriptRoot\..\Artefacts\Packed1" -IncludeTagName

    # those 2 are only useful for testing purposes
    # New-ConfigurationArtefact -Type Script -Enable -Path "$PSScriptRoot\..\Artefacts\Script" -IncludeTagName {
    #     # Lets test this, this will be added in the bottom of the script
    #     Invoke-ModuleBuilder
    # } -ID 'ToGitHubAsScript'
    # New-ConfigurationArtefact -Type ScriptPacked -Enable -Path "$PSScriptRoot\..\Artefacts\ScriptPacked" -ArtefactName "Script-<ModuleName>-$((Get-Date).ToString('yyyy-MM-dd')).zip" {
    #     Invoke-ModuleBuilder
    # } -PreScriptMerge {
    #     # Lets test this
    #     param (
    #         [int]$Mode
    #     )
    # } -ScriptName 'Invoke-ModuleBuilder.ps1'
    # New-ConfigurationArtefact -Type Script -Enable -Path "$PSScriptRoot\..\Artefacts\Script" {
    #     Invoke-ModuleBuilder
    # } -PreScriptMerge {
    #     # Lets test this
    #     param (
    #         [int]$Mode
    #     )
    # } -ScriptName 'Invoke-ModuleBuilder.ps1'

    #New-ConfigurationPublish -Type GitHub -FilePath 'C:\Support\Important\GitHubAPI.txt' -UserName 'EvotecIT' -Enabled:$true -ID 'ToGitHubWithoutModules' -OverwriteTagName 'v1.8.0-Preview1'
    #New-ConfigurationPublish -Type GitHub -FilePath 'C:\Support\Important\GitHubAPI.txt' -UserName 'EvotecIT' -Enabled:$true -ID 'ToGitHubAsScript'
} -ExitCode