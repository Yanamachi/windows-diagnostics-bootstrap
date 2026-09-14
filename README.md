# Windows Diagnostics Bootstrap

포맷 뒤 Windows 진단 환경을 빠르고 안전하게 다시 구성하기 위한 개인용 Bootstrap 저장소입니다.

이 저장소는 **명령으로 안전하게 설치할 수 있는 도구만 자동화**합니다. 로그인, 라이선스, 관리자 드라이버, 실제 진단 데이터와 기기 신뢰는 수동으로 처리합니다.

## 사전 조건

- Windows 11, PowerShell 5.1 이상, 인터넷 연결
- `winget`을 제공하는 App Installer
- 일반 사용자 PowerShell 권한으로 시작; 관리자 권한은 Npcap 등 수동 설치 단계에서만 필요할 수 있음
- 자동 설치는 winget, PyPI, npm에서 패키지를 내려받으므로 실행 전 조직 정책과 패키지 목록을 검토

## 포함하는 것

- Git, GitHub CLI, Python 3.13, Node.js LTS, Bun, Java JDK, Wireshark, DB Browser, Notepad++, `uv`
- Frida, Objection 등 Python 진단 패키지
- npm 전역 도구 목록
- Codex와 MCP의 비밀값 없는 템플릿
- Burp·IDA·JADX·Notion MCP를 안전하게 복원하기 위한 비활성 정의
- 모바일·리버싱·WSL·라이선스 도구의 수동 설치 안내

## 자동화하지 않는 것

- Codex, Orca, GitHub, Notion의 로그인
- IDA Pro, Binary Ninja, Burp Suite의 라이선스 활성화
- Npcap의 관리자 설치 및 옵션 선택
- `C:\mobile` 휴대형 도구 백업 복원
- WSL 배포판 import
- Android 기기 신뢰, ADB 키, Frida 서버 배포
- API 키, OAuth token, Burp 세션, PCAP/APK/DB 등 개인·진단 데이터

## 포맷 전

1. [포맷 전 체크리스트](manual/00_포맷_전_체크리스트.md)를 완료합니다.
2. `C:\mobile`, 라이선스 복구 수단, WSL export, 직접 작성한 Burp 확장을 암호화된 별도 저장소에 백업합니다.
3. 이 저장소에 실제 토큰·라이선스·세션·분석 데이터가 없는지 확인합니다.

```powershell
git status --short
git grep -n -i -E 'api[_-]?key|token|secret|password|authorization|bearer' -- .
```

## 새 PC에서 빠른 시작

### 1. 저장소 가져오기

Git을 이미 설치했다면:

```powershell
git clone https://github.com/Yanamachi/windows-diagnostics-bootstrap.git
cd windows-diagnostics-bootstrap
```

Git이 없다면 GitHub의 **Code → Download ZIP**으로 내려받아 압축을 풀고 PowerShell에서 해당 폴더로 이동합니다. 첫 자동 실행이 Git도 설치합니다.

### 2. 수동 필수 단계

아래 항목은 먼저 또는 병행해 직접 설치·로그인합니다.

1. Codex 설치 및 OpenAI 로그인
2. Orca 설치 및 로그인
3. IDA Pro, Binary Ninja, Burp Suite 설치 및 라이선스 활성화
4. Npcap 설치 (패킷 캡처가 필요할 때)

상세 절차는 [manual](manual) 폴더에 있습니다.

### 3. 자동 설치 미리보기

PowerShell을 일반 사용자 권한으로 열고 실행합니다.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\bootstrap.ps1 -DryRun
```

`-DryRun`은 설치하지 않고 설치 대상과 작업 순서만 보여 줍니다. 패키지 가용성이나 실제 설치 완료를 보장하지는 않습니다.

### 4. 자동 설치 실행

```powershell
.\bootstrap.ps1
```

이 명령은 `winget`, Python 가상환경/pip, npm만 사용합니다. 관리자 권한이 필요한 설치는 억지로 승격하지 않고 실패 이유를 표시합니다.

설치 후 새 명령이 보이지 않으면 PowerShell을 한 번 닫았다가 다시 열고, 아래처럼 단계를 나눠 재실행할 수 있습니다.

### 5. 수동 복원 및 최종 검증

1. `C:\mobile`과 필요한 WSL export를 복원합니다.
2. Codex MCP 템플릿의 실제 경로를 **로컬 설정에만** 넣고 필요한 서버만 켭니다.
3. OAuth MCP는 별도로 로그인합니다. 예: `codex mcp login notion`
4. 전체 도구를 확인합니다.

```powershell
.\scripts\verify-environment.ps1 -RequireMobileTools
```

## Codex와 MCP

`templates/codex.config.toml.template` 및 `templates/codex.mcp.toml.template`은 출발점입니다.

- 기존 `%USERPROFILE%\.codex\config.toml`은 덮어쓰지 않습니다.
- 기존 설정이 있으면 `configure-codex.ps1`은 `.pending` 파일을 만들고 수동 병합을 요구합니다.
- Burp, IDA, JADX, Notion MCP는 기본적으로 `enabled = false`입니다.
- 실제 경로, OAuth 결과, 토큰은 Git에 넣지 않습니다.

현재 활성 MCP는 다음으로 확인합니다.

```powershell
codex mcp list
```

## 자주 쓰는 명령

```powershell
# 전체 자동 설치 미리보기
.\bootstrap.ps1 -DryRun

# 자동 패키지 설치만
.\bootstrap.ps1 -Phase Prerequisites
.\bootstrap.ps1 -Phase Packages

# Codex 템플릿만 안전하게 생성
.\bootstrap.ps1 -Phase Codex

# 설치 상태만 검사
.\bootstrap.ps1 -Phase Verify

# Codex 설정 단계 건너뛰기
.\bootstrap.ps1 -SkipCodexConfiguration
```

## 보안 원칙

`.gitignore`는 비밀값·라이선스·진단 데이터·도구 바이너리·AI 클라이언트 상태를 기본 차단합니다. 템플릿에는 `${VARIABLE_NAME}` 같은 자리표시자만 사용합니다. 실제 값을 추가하기 전에는 반드시 `git status`와 `git diff`를 확인하세요.

## 문제 해결

- `winget`이 없으면 Microsoft Store의 **App Installer**를 설치/업데이트한 뒤 다시 실행합니다.
- `py -3.13`을 찾지 못하면 `bootstrap.ps1 -Phase Prerequisites` 실행 뒤 새 PowerShell을 열어 `py -3.13 --version`을 확인합니다.
- npm 권한 또는 조직 정책 오류는 관리자 권한으로 우회하지 말고 정책과 설치 경로를 확인합니다.
- 기존 Codex 설정이 있으면 `.pending` 파일이 생성됩니다. 내용을 검토해 병합한 뒤에만 MCP를 켭니다.
