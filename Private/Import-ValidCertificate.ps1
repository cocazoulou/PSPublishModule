﻿function Import-ValidCertificate {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    param(
        [parameter(Mandatory, ParameterSetName = 'FilePath')][string] $FilePath,
        [parameter(Mandatory, ParameterSetName = 'Base64')][string] $CertificateAsBase64,
        [parameter(Mandatory)][string] $PfxPassword
    )
    if ($FilePath -and (Test-Path -LiteralPath $FilePath)) {
        $TemporaryFile = $FilePath
    } elseif ($CertificateAsBase64) {
        $TemporaryFile = [io.path]::GetTempFileName()
        if ($PSVersionTable.PSEdition -eq 'Core') {
            Set-Content -AsByteStream -Value $([System.Convert]::FromBase64String($CertificateAsBase64)) -Path $TemporaryFile -ErrorAction Stop
        } else {
            Set-Content -Value $([System.Convert]::FromBase64String($CertificateAsBase64)) -Path $TemporaryFile -Encoding Byte -ErrorAction Stop
        }
    } else {
        return $false
    }
    if ($TemporaryFile) {
        $CodeSigningCert = Import-PfxCertificate -FilePath $pfxCertFilePath -Password $($PfxPassword | ConvertTo-SecureString -AsPlainText -Force) -CertStoreLocation Cert:\CurrentUser\My -ErrorAction Stop
        if ($CodeSigningCert) {
            return $CodeSigningCert
        } else {
            return $false
        }
    } else {
        return $false
    }
}