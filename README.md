# Windows diagnostics bootstrap

This repository reconstructs the command-installable portion of a Windows diagnostics environment after a reset. It deliberately does **not** install or store credentials, licenses, user sessions, device keys, proxy history, binaries, or analysis data.

## Before resetting the PC

1. Complete the backup checklist in [`manual/00_안전_운영_원칙.md`](manual/00_안전_운영_원칙.md).
2. Store licenses, the `C:\mobile` backup, WSL exports, and other private material in encrypted storage outside this repository.
3. Review `manual/` for all manual-only work.
4. Review the Git status and confirm no private files are staged.

## After the reset

1. Install and sign in to Codex and Orca manually.
2. Install/activate IDA, Binary Ninja, Burp, and Npcap manually where selected.
3. Open PowerShell in this repository and run a preview:

   ```powershell
   .\bootstrap.ps1 -DryRun
   ```

4. Run the automatic, command-safe setup:

   ```powershell
   .\bootstrap.ps1
   ```

5. Restore `C:\mobile`, WSL, licenses, and device access manually, then verify:

   ```powershell
   .\scripts\verify-environment.ps1 -RequireMobileTools
   ```

## Safety model

- The installer uses `winget`, Python `venv`/`pip`, and `npm` only for the selected command-safe packages.
- Codex configuration is copied only when no existing config exists. Existing configuration is never overwritten; review `*.pending` files instead.
- MCP definitions start disabled. Add real local paths and authenticate manually before enabling individual servers.
- `manual/` is authoritative for all license, login, driver, WSL, and portable-tool steps.
