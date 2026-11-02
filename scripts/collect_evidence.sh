#!/usr/bin/env bash
# 과제 증거 로그 자동 수집 스크립트
# 사용법 (저장소 최상위 폴더에서, Docker 실행 중인 상태로):
#   bash scripts/collect_evidence.sh
# 결과: docs/evidence.md 에 "명령어 + 출력"이 코드블록으로 기록됨
#
# Windows(Git Bash) / macOS / Linux 공통으로 동작하도록 작성됨.

export MSYS_NO_PATHCONV=1          # Git Bash의 경로 자동 변환 방지 (/data 등)
REPO="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$REPO/docs/evidence.md"
cd "$REPO" || exit 1

# Windows Git Bash 에서는 Docker 바인드 마운트에 C:/... 형식 경로가 필요
if command -v cygpath >/dev/null 2>&1; then
  HOST_APP="$(cygpath -m "$REPO/app")"
else
  HOST_APP="$REPO/app"
fi

# sed -i 는 macOS(BSD)와 Linux/Git Bash(GNU) 문법이 다름
sedi() { if sed --version >/dev/null 2>&1; then sed -i "$@"; else sed -i '' "$@"; fi; }

section() { printf '\n## %s\n\n' "$1" >> "$OUT"; }
note()    { printf '%s\n\n' "$1" >> "$OUT"; }
begin()   { echo '```bash' >> "$OUT"; }
end()     { echo '```' >> "$OUT"; }
run() {   # 명령어와 출력을 함께 기록 (실패해도 계속 진행)
  echo "\$ $1" >> "$OUT"
  ( eval "$1" ) >> "$OUT" 2>&1
  echo "  → $1"
}
mask() {  # 이메일 등 민감정보 마스킹
  sedi -E 's/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/****@****/g; s/(gh[pousr]_)[A-Za-z0-9]+/\1****/g' "$OUT"
}

# 이전 실행 흔적 정리
docker rm -f my-web-8080 my-web-8081 my-web-bind vol-test vol-test2 my-ubuntu ubuntu-test >/dev/null 2>&1
docker compose down >/dev/null 2>&1
docker volume rm mydata >/dev/null 2>&1
sedi 's/Version: <code>v2<\/code>/Version: <code>v1<\/code>/' app/index.html

mkdir -p docs
cat > "$OUT" <<EOF
# 수행 로그 (증거)

> \`scripts/collect_evidence.sh\` 로 자동 수집한 실제 터미널 명령/출력입니다.
> 수집 시각: $(date '+%Y-%m-%d %H:%M:%S %Z')
EOF

echo "▶ 실행 환경"
section "1. 실행 환경"; begin
run 'uname -a'
command -v sw_vers >/dev/null && run 'sw_vers'
command -v cmd.exe >/dev/null && run 'cmd.exe /c ver'
run 'echo $SHELL'
run 'docker --version'
run 'git --version'
end

echo "▶ 터미널 조작"
P="$HOME/codyssey/practice"
rm -rf "$P"
section "2. 터미널 기본 조작"; begin
run 'pwd'
run "mkdir -p \"$P\" && cd \"$P\" && pwd"
cd "$P" || exit 1
run 'touch empty.txt'
run 'echo "hello codyssey" > note.txt'
run 'cat note.txt'
run 'cp note.txt note_copy.txt'
run 'mv note_copy.txt renamed.txt'
run 'mkdir tmpdir && mv renamed.txt tmpdir/'
run 'ls -la'
run 'ls -la tmpdir'
run 'rm tmpdir/renamed.txt && rmdir tmpdir'
run 'ls -la'
run 'cd .. && pwd'                 # 상대 경로 이동 예시
run "ls \"$P/note.txt\""          # 절대 경로 접근 예시
end

echo "▶ 권한 실습"
section "3. 권한 변경 (변경 전/후)"
note "참고: Windows(Git Bash)는 NTFS 특성상 chmod 결과가 제한적으로 반영될 수 있습니다. 이 경우 아래 Docker 컨테이너(Linux) 내 결과를 함께 확인하세요."
begin
run 'ls -l note.txt'
run 'chmod 755 note.txt && ls -l note.txt'
run 'chmod 644 note.txt && ls -l note.txt'
run 'mkdir -p perm_dir && ls -ld perm_dir'
run 'chmod 700 perm_dir && ls -ld perm_dir'
run 'chmod 755 perm_dir && ls -ld perm_dir'
end
note "Linux 컨테이너 안에서 동일 실험:"
begin
run "docker run --rm alpine sh -c 'touch f.txt; mkdir d; ls -l f.txt; ls -ld d; chmod 755 f.txt; chmod 700 d; echo \"--- after ---\"; ls -l f.txt; ls -ld d'"
end
cd "$REPO" || exit 1

echo "▶ Docker 점검"
section "4. Docker 설치 및 데몬 점검"; begin
run 'docker --version'
run 'docker info'
end

echo "▶ 컨테이너 실습"
section "5. hello-world / ubuntu"; begin
run 'docker run hello-world'
run 'docker pull ubuntu'
run 'docker run --rm ubuntu bash -c "ls && echo inside container"'
end
section "6. ubuntu 내부 진입 / attach vs exec 관찰"
note "컨테이너의 bash 에 표준입력(-i)으로 명령을 직접 전달해 내부에서 실행한다."
begin
run 'docker rm -f ubuntu-test >/dev/null 2>&1; printf "ls\necho hello from inside container\nhostname\nexit\n" | docker run -i --name ubuntu-test ubuntu bash'
run 'docker ps -a --filter name=ubuntu-test --format "{{.Names}}  {{.Status}}"'
end
note "**exec**: 실행 중인 컨테이너에 *새 프로세스*를 추가로 띄운다. exec 셸을 exit 해도 메인 프로세스(bash, PID 1)는 그대로라 컨테이너가 유지된다."
begin
run 'docker rm -f my-ubuntu >/dev/null 2>&1; docker run -di --name my-ubuntu ubuntu bash'
run 'printf "echo inside via exec; ps -o pid,cmd; exit\n" | docker exec -i my-ubuntu bash'
run 'docker ps --filter name=my-ubuntu --format "{{.Names}}  {{.Status}}"'
end
note "**attach**: 컨테이너의 *메인 프로세스(PID 1)* 표준입출력에 직접 연결한다. 여기서 exit 하면 메인 프로세스가 끝나므로 컨테이너도 종료된다."
begin
run 'printf "echo inside via attach; exit\n" | docker attach my-ubuntu'
sleep 1
run 'docker ps -a --filter name=my-ubuntu --format "{{.Names}}  {{.Status}}"'
end
note "정리: exec 후 exit → **Up 유지**, attach 후 exit → **Exited**. (attach 상태에서 종료 없이 빠져나오려면 Ctrl+P, Ctrl+Q)"
begin
run 'docker start my-ubuntu && docker stop my-ubuntu && docker ps -a --filter name=my-ubuntu --format "{{.Names}}  {{.Status}}"'
end

echo "▶ 이미지 빌드 / 포트 매핑"
section "7. Dockerfile 커스텀 이미지 빌드"; begin
run 'cat Dockerfile'
run 'docker build -t my-web:1.0 .'
run 'docker images'
end
section "8. 포트 매핑 (2회)"; begin
run 'docker run -d -p 8080:80 --name my-web-8080 my-web:1.0'
run 'docker run -d -p 8081:80 --name my-web-8081 my-web:1.0'
sleep 2
run 'curl -s http://localhost:8080 | grep -E "h1|Version"'
run 'curl -s http://localhost:8081 | grep -E "h1|Version"'
run 'docker ps'
end

echo "▶ 운영 명령"
section "9. Docker 운영 명령"; begin
run 'docker ps -a'
run 'docker logs my-web-8080'
run 'docker stats --no-stream'
run 'docker inspect --format "{{.State.Health.Status}}" my-web-8080'
end

echo "▶ 바인드 마운트"
section "10. 바인드 마운트 반영 (호스트 변경 전/후)"; begin
run "docker run -d -p 8082:80 --name my-web-bind -v \"$HOST_APP:/usr/share/nginx/html\" my-web:1.0"
sleep 2
run 'curl -s http://localhost:8082 | grep Version'
sedi 's/Version: <code>v1<\/code>/Version: <code>v2<\/code>/' app/index.html
echo '$ (호스트에서 app/index.html 의 v1 → v2 수정)' >> "$OUT"
run 'curl -s http://localhost:8082 | grep Version'
end
sedi 's/Version: <code>v2<\/code>/Version: <code>v1<\/code>/' app/index.html

echo "▶ 볼륨 영속성"
section "11. Docker 볼륨 영속성 (컨테이너 삭제 전/후)"; begin
run 'docker volume create mydata'
run 'docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity'
run 'docker exec vol-test bash -c "echo persistent-data > /data/hello.txt && cat /data/hello.txt"'
run 'docker rm -f vol-test'
run 'docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity'
run 'docker exec vol-test2 cat /data/hello.txt'
run 'docker volume inspect mydata'
end

echo "▶ Git"
section "12. Git 설정"; begin
run 'git config --list --show-origin | grep -E "user\.|init\.|remote\.|branch\."'
run 'git remote -v'
run 'git log --oneline -5'
end

if [ "${BONUS:-1}" = "1" ]; then
echo "▶ (보너스) Compose"
section "13. (보너스) Docker Compose"; begin
run 'docker compose up -d --build'
sleep 3
run 'docker compose ps'
run 'docker compose logs --tail 10 helper'
run 'docker compose down'
run 'WEB_PORT=9090 APP_ENV=prod docker compose up -d'
sleep 2
run 'curl -s http://localhost:9090 | grep h1'
sleep 10
run 'docker compose ps'
run 'docker compose logs --tail 6 helper'
run 'docker compose exec web printenv APP_ENV'
run 'docker compose down'
end
fi

# 정리 (브라우저 캡처를 위해 8080/8081 컨테이너는 남겨둠)
docker rm -f my-web-bind vol-test2 my-ubuntu >/dev/null 2>&1
mask

echo
echo "✅ 완료: docs/evidence.md 생성됨"
echo "   브라우저 캡처용으로 http://localhost:8080, http://localhost:8081 이 켜져 있습니다."
