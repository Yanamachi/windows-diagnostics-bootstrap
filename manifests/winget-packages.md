# Intended winget dependencies

Package IDs below are for environment prerequisites only. Verify availability and current IDs on the target Windows machine before installation.

| Package | winget ID | Status |
|---|---|---|
| Git | `Git.Git` | Confident |
| GitHub CLI | `GitHub.cli` | Confident |
| Python 3.13 | `Python.Python.3.13` | Confident; verify exact minor build |
| Node.js | `OpenJS.NodeJS` | Confident; verify required major version (inventory says Node 24) |
| uv | TODO_VERIFY_WINGET_ID | Manual verification |
| Java JDK | TODO_VERIFY_WINGET_ID | Manual verification; required by Ghidra/JADX |
| Bun | TODO_VERIFY_WINGET_ID | Manual verification |
| Wireshark | TODO_VERIFY_WINGET_ID | Manual verification |
| DB Browser for SQLite | TODO_VERIFY_WINGET_ID | Manual verification |
| Notepad++ | TODO_VERIFY_WINGET_ID | Manual verification |

Portable analysis tools (Ghidra, JADX, platform-tools, radare2/r2frida, apktool) are tracked in `tools.lock.json` and are not assigned unverified winget IDs.
