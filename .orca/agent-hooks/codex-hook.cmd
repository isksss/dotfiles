@echo off
setlocal
if defined ORCA_AGENT_HOOK_ENDPOINT if exist "%ORCA_AGENT_HOOK_ENDPOINT%" call "%ORCA_AGENT_HOOK_ENDPOINT%" 2>nul
if "%ORCA_AGENT_HOOK_PORT%"=="" exit /b 0
if "%ORCA_AGENT_HOOK_TOKEN%"=="" exit /b 0
if "%ORCA_PANE_KEY%"=="" exit /b 0
"%SystemRoot%\System32\curl.exe" -sS -X POST "http://127.0.0.1:%ORCA_AGENT_HOOK_PORT%/hook/codex" --connect-timeout 0.5 --max-time 1.5 -H "Content-Type: application/x-www-form-urlencoded" -H "X-Orca-Agent-Hook-Token: %ORCA_AGENT_HOOK_TOKEN%" --data-urlencode "paneKey=%ORCA_PANE_KEY%" --data-urlencode "tabId=%ORCA_TAB_ID%" --data-urlencode "launchToken=%ORCA_AGENT_LAUNCH_TOKEN%" --data-urlencode "worktreeId=%ORCA_WORKTREE_ID%" --data-urlencode "env=%ORCA_AGENT_HOOK_ENV%" --data-urlencode "version=%ORCA_AGENT_HOOK_VERSION%" --data-urlencode "payload@-" >nul 2>&1
exit /b 0
:orca_agent_hook_drain_stdin
"%SystemRoot%\System32\more.com" >nul 2>nul
exit /b 0
