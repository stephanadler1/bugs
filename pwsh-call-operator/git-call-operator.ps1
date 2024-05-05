# Copyright (c) Stephan Adler.

<#
.DESCRIPTION
This test uses Git to find the first tag that matches the name in $existingTagPrefix.
When using pwsh.exe that regular use of the call operator (&) will yield no result.
With powershell.exe the call operator will work and the correct hash is returned.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$global:DebugPreference = 'Continue'
Write-Debug "PSVersion = $($PSVersionTable.PSVersion); PSEdition = $($PSVersionTable.PSEdition); ExecutionPolicy = $(Get-ExecutionPolicy)"


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

# First reliably find the commit we want.
$script:commitHash = Invoke-Tool $gitTool $gitArgs
Write-Host "Actual commit: $commitHash"

# Now invoke git as we would normally do... to domenstrate the different behaviors.
Write-Debug "NOW THE TEST: Using the call operator to invoke $gitTool $gitArgs"
$commitHash = & $gitTool $gitArgs
Write-Debug "Exit code: $LASTEXITCODE"
Write-Host "Found commit: $commitHash"
if ([string]::IsNullOrWhitespace($commitHash))
{
    throw 'Git commit shouldn''t be empty'
}
