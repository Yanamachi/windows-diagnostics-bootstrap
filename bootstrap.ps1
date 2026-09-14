[CmdletBinding()]
param(
    [ValidateSet('All', 'Prerequisites', 'Packages', 'Codex', 'Verify')]
    [string]$Phase = 'All',
    [switch]$DryRun,
    [switch]$SkipCodexConfiguration
)

$ErrorActionPreference = 'Stop'
$scriptRoot = Join-Path $PSScriptRoot 'scripts'

function Refresh-ProcessPath {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"
}

if ($Phase -in @('All', 'Prerequisites')) {
    & (Join-Path $scriptRoot 'install-prerequisites.ps1') -DryRun:$DryRun
    if (-not $DryRun) { Refresh-ProcessPath }
}

if ($Phase -in @('All', 'Packages')) {
    & (Join-Path $scriptRoot 'install-python-tools.ps1') -DryRun:$DryRun
    & (Join-Path $scriptRoot 'install-node-tools.ps1') -DryRun:$DryRun
}

if (($Phase -in @('All', 'Codex')) -and -not $SkipCodexConfiguration) {
    & (Join-Path $scriptRoot 'configure-codex.ps1') -DryRun:$DryRun
}

if (($Phase -in @('All', 'Verify')) -and -not $DryRun) {
    & (Join-Path $scriptRoot 'verify-environment.ps1')
}
