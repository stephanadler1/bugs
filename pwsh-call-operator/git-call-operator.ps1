# Copyright (c) Stephan Adler.

<#
.SYNOPSIS

.DESCRIPTION
See https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10.
#>

# My standard preamble for all PowerShell scripts.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (-not ([System.String]::IsNullOrWhitespace($env:_DEBUG)))
{
    $global:DebugPreference = 'Continue'
    Write-Debug "PSVersion = $($PSVersionTable.PSVersion); PSEdition = $($PSVersionTable.PSEdition); ExecutionPolicy = $(Get-ExecutionPolicy)"
}

[string] $script:existingTagPrefix = 'pwsh-test-tag'


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


$script:gitTool = 'git.exe'

$script:gitArgs = @(
    'log',
    '-n', '1',
    "--tags=`"$($existingTagPrefix)*`"",
    '--format="%H"'
)

$script:commitHash = Invoke-Tool $gitTool $gitArgs
Write-Host "Actual commit: $commitHash"


$commitHash = & $gitTool $gitArgs
Write-Host "Commit: $commitHash"
if ([string]::IsNullOrWhitespace($commitHash))
{
    throw 'Git commit shouldn''t be empty'
}
