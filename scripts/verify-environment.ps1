[CmdletBinding()]
param(
    [string]$MobileToolsRoot = 'C:\mobile',
    [switch]$RequireMobileTools
)

$checks = @(
    @{ Name = 'git'; Command = 'git'; Arguments = @('--version') },
    @{ Name = 'gh'; Command = 'gh'; Arguments = @('--version') },
    @{ Name = 'python'; Command = 'py'; Arguments = @('-3.13', '--version') },
    @{ Name = 'node'; Command = 'node'; Arguments = @('--version') },
    @{ Name = 'npm'; Command = 'npm'; Arguments = @('--version') },
    @{ Name = 'bun'; Command = 'bun'; Arguments = @('--version') },
    @{ Name = 'java'; Command = 'java'; Arguments = @('--version') },
    @{ Name = 'uv'; Command = 'uv'; Arguments = @('--version') },
    @{ Name = 'adb'; Command = 'adb'; Arguments = @('version') },
    @{ Name = 'radare2'; Command = 'r2'; Arguments = @('-v') }
)

$results = foreach ($check in $checks) {
    $available = Get-Command $check.Command -ErrorAction SilentlyContinue
    [pscustomobject]@{ Name = $check.Name; Available = ($null -ne $available); Path = if ($available) { $available.Source } else { $null } }
}

$expectedMobileFolders = @('ghidra_11.3.2_PUBLIC', 'jadx-gui-1.5.6-win', 'platform-tools')
foreach ($folder in $expectedMobileFolders) {
    $path = Join-Path $MobileToolsRoot $folder
    $results += [pscustomobject]@{ Name = "mobile:$folder"; Available = (Test-Path -LiteralPath $path); Path = $path }
}

$results | Format-Table -AutoSize
if (Get-Command codex -ErrorAction SilentlyContinue) {
    Write-Host "`nCodex MCP status:"
    & codex mcp list
}

$requiredResults = $results | Where-Object {
    $_.Name -notlike 'mobile:*' -or $RequireMobileTools
}
if (($requiredResults | Where-Object { -not $_.Available }).Count -gt 0) { exit 1 }
