[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$packages = @(
    @{ Id = 'Git.Git'; Name = 'Git' },
    @{ Id = 'GitHub.cli'; Name = 'GitHub CLI' },
    @{ Id = 'Python.Python.3.13'; Name = 'Python 3.13' },
    @{ Id = 'OpenJS.NodeJS.LTS'; Name = 'Node.js 24 LTS' },
    @{ Id = 'Oven-sh.Bun'; Name = 'Bun' },
    @{ Id = 'EclipseAdoptium.Temurin.26.JDK'; Name = 'Temurin JDK 26' },
    @{ Id = 'WiresharkFoundation.Wireshark'; Name = 'Wireshark' },
    @{ Id = 'DBBrowserForSQLite.DBBrowserForSQLite'; Name = 'DB Browser for SQLite' },
    @{ Id = 'Notepad++.Notepad++'; Name = 'Notepad++' },
    @{ Id = 'astral-sh.uv'; Name = 'uv' }
)

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw 'winget is required. Install/update App Installer, then rerun this script.'
}

foreach ($package in $packages) {
    Write-Host "[$($package.Name)] $($package.Id)"
    if ($DryRun) { continue }

    & winget install --id $package.Id --exact --source winget --accept-source-agreements --accept-package-agreements --disable-interactivity
    if ($LASTEXITCODE -ne 0) {
        throw "Installation failed: $($package.Id) (exit code $LASTEXITCODE)"
    }
}

if ($DryRun) {
    Write-Host 'Dry run completed; no prerequisites were installed.'
} else {
    Write-Host 'Prerequisites installed. Reopen the terminal if a newly installed command is not found.'
}
