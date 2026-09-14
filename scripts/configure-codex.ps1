[CmdletBinding()]
param([switch]$DryRun)

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$templateRoot = Join-Path $repositoryRoot 'templates'
$codexRoot = Join-Path $env:USERPROFILE '.codex'
$configPath = Join-Path $codexRoot 'config.toml'
$configTemplate = Join-Path $templateRoot 'codex.config.toml.template'
$mcpTemplate = Join-Path $templateRoot 'codex.mcp.toml.template'

if ((-not (Test-Path -LiteralPath $configTemplate)) -or (-not (Test-Path -LiteralPath $mcpTemplate))) {
    throw 'Codex templates are missing.'
}

if ($DryRun) {
    Write-Host "Would create $codexRoot if needed."
    Write-Host 'Would copy config.toml only when one does not already exist.'
    Write-Host 'Would otherwise write non-destructive .pending template files for manual merge.'
    exit 0
}

New-Item -ItemType Directory -Force -Path $codexRoot | Out-Null
if (-not (Test-Path -LiteralPath $configPath)) {
    Copy-Item -LiteralPath $configTemplate -Destination $configPath
    Add-Content -LiteralPath $configPath -Value "`n# MCP definitions; replace local path placeholders before enabling.`n"
    Get-Content -Raw -LiteralPath $mcpTemplate | Add-Content -LiteralPath $configPath
    Write-Host "Created $configPath with all MCP servers disabled."
} else {
    Copy-Item -LiteralPath $configTemplate -Destination (Join-Path $codexRoot 'config.toml.bootstrap.pending') -Force
    Copy-Item -LiteralPath $mcpTemplate -Destination (Join-Path $codexRoot 'mcp.toml.bootstrap.pending') -Force
    Write-Warning 'An existing Codex config was preserved. Review and merge the two .pending files manually.'
}

if (Get-Command codex -ErrorAction SilentlyContinue) {
    & codex mcp list
} else {
    Write-Warning 'Codex is not installed or not on PATH. Install and log in manually, then rerun this command.'
}
