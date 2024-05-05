# Copyright (c) Stephan Adler.

<#
.DESCRIPTION
This test demonstrates a difference in behavior when AzCopy is invoked to upload data to a storage account
while excluding files and folders from the upload.

In PowerShell Desktop the behavior is expected and only a single file (`the-only-file-that-should-exist.txt`)
is being uploaded from the `upload-data` folder.

In PowerShell Core the behavior has changed and only some (!?) files or folders are excluded from the upload,
but most end up in the storage account.

See https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$global:DebugPreference = 'Continue'
Write-Debug "PSVersion = $($PSVersionTable.PSVersion); PSEdition = $($PSVersionTable.PSEdition); ExecutionPolicy = $(Get-ExecutionPolicy)"

# Provide your own blob storage account URI here including a container and a final /.
[string] $baseBlobUri = ''

# Provide your own SAS token that grants full access.
[string] $sasUriToken = ''

# In case you ignored the comments above
if ([string]::IsNullOrWhitespace($sasUriToken) -or [string]::IsNullOrWhitespace($baseBlobUri))
{
    Write-Host
    Write-Host "In order you run this test you need to:"
    Write-Host '1. Create a storage account in Azure, general-purpose v2 LRS.'
    Write-Host '2. Configure it to accept SAS tokens for authentication.'
    Write-Host '3. Create a container and place the base URI in variable $baseBlobUri.'
    Write-Host '4. Create a SAS token and put it in variable $sasUriToken.'
    Write-Host 'Run the tests by invoking execute-tests.cmd.'
    Write-Host

    throw
}


function Invoke-Tool
{
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $FilePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]] $ArgumentList
    )

    $private:useMitigation = $false
    if (($PSVersionTable.PSEdition -ieq 'Core') -and ($IsWindows -eq $true))
    {
        [string[]] $private:updatedArgs = @()
        $ArgumentList | ForEach-Object {
            if (($_ -match '(%| |&)') -and -not $_.StartsWith('"'))
            {
                $updatedArgs += "`"$_`""
                $useMitigation = $true
            }
            else
            {
                $updatedArgs += $_
            }
        }
    }

    if ($useMitigation)
    {
        Write-Debug "Tool invocation (with Core mitigation!): $FilePath $updatedArgs"
        & $env:ComSpec /c "$FilePath $updatedArgs"
    }
    else
    {
        Write-Debug "Tool invocation: $FilePath $ArgumentList"
        & $FilePath $ArgumentList
    }

    Write-Debug "Tool invocation -> Exit code: $LASTEXITCODE"
}


# The standard AZCOPY arguments
$script:azCopyDefaultArgs = @('--put-md5')

# The specific AXCOPY arguments for this upload.
$script:azCopyArgs = @(
    'sync',
    "$(Join-Path -Path (Split-Path $script:MyInvocation.MyCommand.Path -Parent) -ChildPath 'upload-data')",
    "$($baseBlobUri)$((Get-Process -Id $PID).ProcessName)/$($sasUriToken)",
    '--recursive=true',
    '--delete-destination=true',
    '--exclude-pattern="1.txt;Global.asax;web.config"',
    '--exclude-path="ignore1/;ignore2/;ignore3/;ignore4/"'
)

# ... just in case that will make a difference.
$azCopyArgs += $azCopyDefaultArgs

# A (potential) list of more tools to invoke.
$tools = @(
    'azcopy.exe'
)

$tools | ForEach-Object {
    Write-Host $_
    Write-Host 'The number of scanned/uploaded files is 7 (fail) for Core and 1 (expected) for Desktop.'
    & $_ $azCopyArgs
    Write-Host
    Write-Host
}

# Upload with the mitigation to a different folder.
$azCopyArgs[2] = $azCopyArgs[2].Replace($baseBlobUri, "$($baseBlobUri)mitigated/")
$tools | ForEach-Object {
    Write-Host 'Invoke-Tool' $_
    Write-Host 'The number of scanned/uploaded files is 1, as expected.'
    Invoke-Tool $_ $azCopyArgs
    Write-Host
    Write-Host
}
