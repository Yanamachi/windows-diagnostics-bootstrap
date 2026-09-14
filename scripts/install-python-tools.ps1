[CmdletBinding()]
param(
    [string]$EnvironmentPath = (Join-Path $PSScriptRoot '..\.venv'),
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$requirementsPath = Join-Path $repositoryRoot 'manifests\python-requirements.txt'

if (-not (Test-Path -LiteralPath $requirementsPath)) {
    throw "Requirements file is missing: $requirementsPath"
}
if (-not (Get-Command py -ErrorAction SilentlyContinue)) {
    throw 'Python launcher (py) was not found. Run install-prerequisites.ps1 first.'
}

$environmentPath = [System.IO.Path]::GetFullPath($EnvironmentPath)
$pythonPath = Join-Path $environmentPath 'Scripts\python.exe'
if ($DryRun) {
    Write-Host "Would create/update virtual environment: $environmentPath"
    Write-Host "Would install: $requirementsPath"
    exit 0
}

if (-not (Test-Path -LiteralPath $pythonPath)) {
    & py -3.13 -m venv $environmentPath
    if ($LASTEXITCODE -ne 0) { throw 'Failed to create the Python 3.13 virtual environment.' }
}

& $pythonPath -m pip install --upgrade pip
& $pythonPath -m pip install -r $requirementsPath
& $pythonPath -m pip check
if ($LASTEXITCODE -ne 0) { throw 'Python package validation failed.' }
