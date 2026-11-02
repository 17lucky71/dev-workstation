@echo off
chcp 65001 >nul
REM === 더블클릭 한 번으로 과제 로그 수집 + GitHub 업로드 (Windows) ===
REM 사전 준비: Docker Desktop 실행 중, Git for Windows 설치됨
cd /d "%~dp0"

docker info >nul 2>&1
if errorlevel 1 (
  echo [오류] Docker Desktop이 실행 중이 아닙니다. Docker Desktop을 켜고 고래 아이콘이 멈춘 뒤 다시 실행하세요.
  pause
  exit /b 1
)

set "GITBASH=%ProgramFiles%\Git\bin\bash.exe"
if not exist "%GITBASH%" (
  echo [오류] Git for Windows가 설치되어 있지 않습니다. https://git-scm.com 에서 설치하세요.
  pause
  exit /b 1
)

git config --global user.name >nul 2>&1 || git config --global user.name "17lucky71"
git config --global init.defaultBranch main

"%GITBASH%" scripts/collect_evidence.sh

git add -A
git commit -m "add evidence logs (collected on my PC)"
git push

echo.
echo 완료! 이제 브라우저에서 http://localhost:8080 과 http://localhost:8081 을 열어 캡처하세요.
start http://localhost:8080
start http://localhost:8081
pause
