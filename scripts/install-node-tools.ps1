[CmdletBinding()]
param([switch]$DryRun)

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $repositoryRoot 'manifests\npm-global-packages.txt'

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw 'npm was not found. Run install-prerequisites.ps1 first and reopen the terminal.'
}
if (-not (Test-Path -LiteralPath $manifestPath)) {
    throw "npm manifest is missing: $manifestPath"
}

$packages = Get-Content -LiteralPath $manifestPath | Where-Object { $_.Trim() -and -not $_.Trim().StartsWith('#') }
foreach ($package in $packages) {
    Write-Host "[npm] $package"
    if (-not $DryRun) {
        & npm install --global $package
        if ($LASTEXITCODE -ne 0) { throw "npm installation failed: $package" }
    }
}

if (-not $DryRun) { & npm list --global --depth=0 }
