# 개발 워크스테이션 구축 (Codyssey 입학연수 · 개발 입문)

> 📄 **모든 명령의 실제 출력 로그는 [docs/evidence.md](docs/evidence.md)** 에 있습니다.
> 로그는 [`scripts/collect_evidence.sh`](scripts/collect_evidence.sh) 로 자동 수집했으며, 누구나 같은 명령으로 재현할 수 있습니다.
> 이메일·토큰 등 민감정보는 `****` 로 자동 마스킹됩니다.

### 재현 방법
```bash
git clone https://github.com/17lucky71/dev-workstation.git
cd dev-workstation
bash scripts/collect_evidence.sh      # Docker(OrbStack / Docker Desktop) 실행 상태에서
```

## 0) 프로젝트 개요
터미널·Docker·Git을 직접 세팅하고, NGINX 기반 커스텀 이미지를 만들어 포트 매핑, 바인드 마운트, 볼륨 영속성을 검증한다. 누가 실행해도 같은 결과가 나오는 **재현 가능한 실행 환경**을 만드는 것이 목표다.


### 핵심 검증 결과 요약
| 항목 | 결과 | 근거 |
|---|---|---|
| Docker 동작 | `Docker version 29.9.2`, `docker info` Server 응답, `Hello from Docker!` | [§4~5](docs/evidence.md#4-docker-설치-및-데몬-점검) |
| 커스텀 이미지 | `my-web:1.0` 빌드 성공 (nginx:alpine 기반) | [§7](docs/evidence.md#7-dockerfile-커스텀-이미지-빌드) |
| 포트 매핑 2회 | 8080, 8081 모두 `Hello from my custom NGINX container!` 응답 | [§8](docs/evidence.md#8-포트-매핑-2회) |
| 바인드 마운트 | 호스트 파일 수정 후 재빌드 없이 `v1 → v2` 반영 | [§10](docs/evidence.md#10-바인드-마운트-반영-호스트-변경-전후) |
| 볼륨 영속성 | `vol-test` 삭제 후 새 컨테이너에서 `persistent-data` 유지 | [§11](docs/evidence.md#11-docker-볼륨-영속성-컨테이너-삭제-전후) |
| 권한 변경 | 컨테이너에서 `-rw-r--r--` → `-rwxr-xr-x`(755), `drwxr-xr-x` → `drwx------`(700) | [§3](docs/evidence.md#3-권한-변경-변경-전후) |
| attach vs exec | exec 후 exit → `Up` 유지, attach 후 exit → `Exited (0)` | [§6](docs/evidence.md#6-ubuntu-내부-진입--attach-vs-exec-관찰) |
| Compose / 환경 변수 | web+helper 2개 서비스, helper→web 이름으로 통신, `APP_ENV=prod`·포트 9090 주입 | [§13](docs/evidence.md#13-보너스-docker-compose) |

## 1) 실행 환경
| 항목 | 값 |
|---|---|
| OS | Windows 11 (10.0.26200) |
| Shell / Terminal | bash / Git Bash (MINGW64) |
| Container Runtime | Docker Desktop 4.97.0 (WSL 2 백엔드) — macOS는 OrbStack으로 대체 가능 |
| Docker | Docker Desktop 4.97.0 (Engine 29.9.2, WSL 2 백엔드) |
| Git | 2.56.0.windows.4 |

## 2) 수행 체크리스트
- [x] 터미널 기본 조작 및 폴더 구성
- [x] 권한 변경 실습 (파일 1, 디렉토리 1)
- [x] Docker 설치/점검 (`--version`, `info`)
- [x] Docker 운영 명령 (`images`, `ps -a`, `logs`, `stats`)
- [x] hello-world / ubuntu 컨테이너 내부 명령 실행
- [x] attach vs exec 차이 관찰
- [x] Dockerfile 커스텀 이미지 빌드/실행
- [x] 포트 매핑 접속 (2회)
- [x] 바인드 마운트 반영
- [x] 볼륨 영속성
- [x] Git 설정 + VSCode GitHub 연동
- [x] (보너스) Docker Compose 단일·멀티 컨테이너 / 운영 명령 / 환경 변수
- [ ] (보너스) GitHub SSH 키 — 미수행 (HTTPS + Git Credential Manager 사용)

## 3) 저장소 구조
```
.
├── app/index.html        # 웹 서버 정적 콘텐츠
├── Dockerfile            # nginx:alpine 기반 커스텀 이미지
├── docker-compose.yml    # (보너스) web + helper
├── docs/evidence.md      # 자동 수집된 명령/출력 로그
├── docs/screenshots/     # 브라우저/VSCode 캡처
├── scripts/collect_evidence.sh
└── README.md
```

---

## 4) 터미널 조작 로그
> 실행 위치: Windows 11 · Git Bash. 전체 출력 → [evidence §2](docs/evidence.md#2-터미널-기본-조작)

```bash
$ pwd                                            # 현재 위치 확인
/c/Users/82103/dev-workstation
$ mkdir -p ~/codyssey/practice && cd ~/codyssey/practice && pwd   # 생성 + 이동
/c/Users/82103/codyssey/practice
$ touch empty.txt                                # 빈 파일 생성
$ echo "hello codyssey" > note.txt
$ cat note.txt                                   # 파일 내용 확인
hello codyssey
$ cp note.txt note_copy.txt                      # 복사
$ mv note_copy.txt renamed.txt                   # 이름 변경
$ mkdir tmpdir && mv renamed.txt tmpdir/         # 이동
$ ls -la                                         # 숨김 파일 포함 목록 (., .. 표시)
drwxr-xr-x 1 82103 197609  0 Nov  2 16:53 .
drwxr-xr-x 1 82103 197609  0 Nov  2 16:53 ..
-rw-r--r-- 1 82103 197609  0 Nov  2 16:53 empty.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:53 note.txt
drwxr-xr-x 1 82103 197609  0 Nov  2 16:53 tmpdir
$ rm tmpdir/renamed.txt && rmdir tmpdir          # 삭제
$ ls -la
-rw-r--r-- 1 82103 197609  0 Nov  2 16:53 empty.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:53 note.txt
```

**절대 경로 vs 상대 경로**
- 절대 경로: 루트(`/`)부터 전체 위치를 적는다 → `/c/Users/82103/codyssey/practice/note.txt` (어디서 실행해도 같은 파일)
- 상대 경로: *현재 위치* 기준 → `cd ..` 는 한 단계 위, `./note.txt` 는 현재 폴더의 파일 (현재 위치에 따라 가리키는 대상이 달라짐)

## 5) 권한 실습 (파일 1, 디렉토리 1)
> 전체 출력 → [evidence §3](docs/evidence.md#3-권한-변경-변경-전후)

Windows(NTFS)에서는 `chmod` 가 반영되지 않아([트러블슈팅 ④](#15-트러블슈팅)) **리눅스 컨테이너 안에서** 실험했다.
```bash
$ docker run --rm alpine sh -c 'touch f.txt; mkdir d; ls -l f.txt; ls -ld d; chmod 755 f.txt; chmod 700 d; echo "--- after ---"; ls -l f.txt; ls -ld d'
-rw-r--r--    1 root  root     0 Nov  2 07:53 f.txt     # 변경 전 파일: 644
drwxr-xr-x    2 root  root  4096 Nov  2 07:53 d         # 변경 전 디렉토리: 755
--- after ---
-rwxr-xr-x    1 root  root     0 Nov  2 07:53 f.txt     # 변경 후 파일: 755
drwx------    2 root  root  4096 Nov  2 07:53 d         # 변경 후 디렉토리: 700
```
**해석 규칙**: r=4, w=2, x=1 을 더한 숫자 3자리 = 소유자 / 그룹 / 기타
- `755` = `rwx r-x r-x` → 소유자는 모두, 나머지는 읽기·실행만
- `644` = `rw- r-- r--` → 소유자는 읽기·쓰기, 나머지는 읽기만
- `700` = `rwx --- ---` → 소유자만 접근
- 디렉토리의 `x` 는 "그 안으로 들어갈(cd) 수 있는 권한"

## 6) Docker 설치 및 점검
> 전체 출력 → [evidence §4](docs/evidence.md#4-docker-설치-및-데몬-점검)
```bash
$ docker --version
Docker version 29.9.2, build a82e528
$ docker info
Server:
 Server Version: 29.9.2
 Kernel Version: 6.18.54.1-microsoft-standard-WSL2
 Operating System: Docker Desktop
 ...                       # Server 정보가 나오면 데몬이 동작 중
```

## 7) 컨테이너 실행 실습
> 전체 출력 → [evidence §5~6](docs/evidence.md#5-hello-world--ubuntu)
```bash
$ docker run hello-world
Hello from Docker!
This message shows that your installation appears to be working correctly.
```
**ubuntu 컨테이너 내부에서 명령 실행** (bash 에 표준입력으로 명령 전달)
```bash
$ printf "ls\necho hello from inside container\nhostname\nexit\n" | docker run -i --name ubuntu-test ubuntu bash
bin  boot  dev  etc  home  lib ... usr  var
hello from inside container
7c2fc605d172                     # 컨테이너 ID = 컨테이너 안의 hostname
```
**attach vs exec 관찰**
```bash
$ docker run -di --name my-ubuntu ubuntu bash
$ printf "echo inside via exec; ps -o pid,cmd; exit\n" | docker exec -i my-ubuntu bash
inside via exec
    PID CMD
      1 bash                     # 메인 프로세스
      7 bash                     # exec 로 추가된 프로세스
$ docker ps --filter name=my-ubuntu --format "{{.Names}}  {{.Status}}"
my-ubuntu  Up Less than a second              # ← exec 종료 후에도 유지

$ printf "echo inside via attach; exit\n" | docker attach my-ubuntu
$ docker ps -a --filter name=my-ubuntu --format "{{.Names}}  {{.Status}}"
my-ubuntu  Exited (0) 1 second ago            # ← attach 에서 exit → 종료
```
| | 연결 대상 | exit 하면 |
|---|---|---|
| `exec` | 새로 띄운 별도 프로세스 | 그 프로세스만 종료, **컨테이너 유지** |
| `attach` | 메인 프로세스(PID 1) | 메인 프로세스 종료 → **컨테이너 종료** (빠져나오기만: `Ctrl+P, Ctrl+Q`) |

## 8) Docker 운영 명령
> 전체 출력 → [evidence §7, §9](docs/evidence.md#9-docker-운영-명령)
```bash
$ docker images
IMAGE                ID             DISK USAGE   CONTENT SIZE
alpine:latest        be2656061b53         13MB         3.94MB
hello-world:latest   c567b231f656       25.9kB         9.49kB
my-web:1.0           e3391dfda803       93.6MB         26.3MB
ubuntu:latest        6a06111c3b0a        163MB         45.9MB
$ docker ps -a            # 실행 중 + 종료된 컨테이너 전체
$ docker logs my-web-8080
... nginx/1.31.8 ... start worker processes
172.17.0.1 - - [02/Nov/2026:07:54:..] "GET / HTTP/1.1" 200 526 "-" "curl/8.23.0"
$ docker stats --no-stream
NAME          CPU %     MEM USAGE / LIMIT     MEM %
my-web-8081   0.00%     11.78MiB / 7.612GiB   0.15%
my-web-8080   0.00%     12.11MiB / 7.612GiB   0.16%
$ docker stop my-ubuntu   # 중지 → docker ps -a 에서 Exited 확인
```

## 9) 커스텀 이미지 (Dockerfile)
- **선택한 베이스**: 공식 `nginx:alpine` 이미지 — 방식 (A) 웹 서버 베이스 + 정적 콘텐츠 교체
- 소스: [`Dockerfile`](Dockerfile), [`app/index.html`](app/index.html)

| 커스텀 포인트 | 목적 |
|---|---|
| `LABEL` | 이미지 이름/설명 메타데이터 → 이미지 식별·관리 |
| `ENV APP_ENV=dev` | 실행 모드를 코드 밖 설정으로 분리 |
| `COPY app/ /usr/share/nginx/html/` | NGINX 기본 페이지를 내 페이지로 교체 |
| `HEALTHCHECK` | 컨테이너가 실제로 응답하는지 Docker가 주기적으로 점검 |

```bash
$ docker build -t my-web:1.0 .
#5 [1/2] FROM docker.io/library/nginx:alpine
#6 [2/2] COPY app/ /usr/share/nginx/html/
#7 naming to docker.io/library/my-web:1.0 done
```
> 전체 빌드 로그 → [evidence §7](docs/evidence.md#7-dockerfile-커스텀-이미지-빌드)

## 10) 포트 매핑 및 접속 (2회)
```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
$ curl -s http://localhost:8080 | grep h1
  <h1>Hello from my custom NGINX container!</h1>
$ curl -s http://localhost:8081 | grep h1
  <h1>Hello from my custom NGINX container!</h1>
$ docker ps
IMAGE        STATUS          PORTS                    NAMES
my-web:1.0   Up 2 seconds    0.0.0.0:8081->80/tcp     my-web-8081
my-web:1.0   Up 3 seconds    0.0.0.0:8080->80/tcp     my-web-8080
```
| localhost:8080 | localhost:8081 |
|---|---|
| ![8080 접속](docs/screenshots/port-8080.png) | ![8081 접속](docs/screenshots/port-8081.png) |

**포트 매핑이 필요한 이유**: 컨테이너는 격리된 자기만의 네트워크를 가져서, 컨테이너 안의 80번 포트는 밖(브라우저)에서 바로 보이지 않는다. `-p 호스트포트:컨테이너포트` 로 내 PC의 포트를 컨테이너 포트에 연결해야 접속할 수 있다. 호스트 포트만 다르게 하면(8080, 8081) 같은 이미지를 여러 개 동시에 띄울 수 있다.

## 11) 바인드 마운트 반영 (호스트 변경 전/후)
> 전체 출력 → [evidence §10](docs/evidence.md#10-바인드-마운트-반영-호스트-변경-전후)
```bash
$ docker run -d -p 8082:80 --name my-web-bind \
    -v "C:/Users/82103/dev-workstation/app:/usr/share/nginx/html" my-web:1.0
$ curl -s http://localhost:8082 | grep Version
  <p>Version: <code>v1</code></p>                # 변경 전
$ sed -i 's/v1/v2/' app/index.html               # 호스트(내 PC)에서 파일 수정
$ curl -s http://localhost:8082 | grep Version
  <p>Version: <code>v2</code></p>                # 변경 후: 재빌드 없이 즉시 반영
```
**바인드 마운트**: 내 PC의 폴더를 컨테이너 안 경로에 그대로 연결 → 개발 중 코드 수정을 바로 확인할 때 사용.

## 12) Docker 볼륨 영속성 (컨테이너 삭제 전/후)
> 전체 출력 → [evidence §11](docs/evidence.md#11-docker-볼륨-영속성-컨테이너-삭제-전후)
```bash
$ docker volume create mydata
mydata
$ docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity
$ docker exec vol-test bash -c "echo persistent-data > /data/hello.txt && cat /data/hello.txt"
persistent-data                                  # 삭제 전: 데이터 기록
$ docker rm -f vol-test                          # 컨테이너 삭제
vol-test
$ docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
$ docker exec vol-test2 cat /data/hello.txt
persistent-data                                  # 삭제 후 새 컨테이너: 데이터 유지
$ docker volume inspect mydata
"Mountpoint": "/var/lib/docker/volumes/mydata/_data"
```
**볼륨이란**: 컨테이너와 별개로 Docker가 관리하는 저장 공간. 컨테이너는 지우고 다시 만드는 일회용이지만, 볼륨에 둔 데이터(DB 파일 등)는 컨테이너를 삭제해도 남는다.

## 13) Git 설정 및 GitHub 연동
> 전체 출력 → [evidence §12](docs/evidence.md#12-git-설정)
```bash
$ git config --global user.name "..."
$ git config --global user.email "****@****"
$ git config --global init.defaultBranch main
$ git config --list --show-origin | grep -E "user\.|init\.|remote\.|branch\."
file:C:/Users/82103/.gitconfig   user.name=최영진
file:C:/Users/82103/.gitconfig   user.email=****@****
file:C:/Users/82103/.gitconfig   init.defaultbranch=main
file:.git/config                 remote.origin.url=https://github.com/17lucky71/dev-workstation.git
file:.git/config                 branch.main.remote=origin
```
![VSCode GitHub 연동](docs/screenshots/vscode-github.png)

- 왼쪽 아래 계정 메뉴: **17lucky71 (GitHub)** 로그인 확인
- 상태 표시줄: `main` 브랜치 표시 → 로컬 저장소가 `origin`(GitHub)과 연동됨

**Git vs GitHub**: Git은 내 컴퓨터에서 변경 이력(커밋)을 관리하는 **로컬 버전관리 도구**이고, GitHub는 그 저장소를 인터넷에 올려 공유·리뷰·협업하는 **원격 플랫폼**이다. (`git commit` = 로컬 기록, `git push` = GitHub로 업로드)

## 14) (보너스) Docker Compose · 환경 변수
> 파일: [`docker-compose.yml`](docker-compose.yml) · 전체 출력 → [evidence §13](docs/evidence.md#13-보너스-docker-compose)
```bash
$ WEB_PORT=9090 APP_ENV=prod docker compose up -d     # 환경 변수로 포트/모드 주입
$ docker compose ps
SERVICE   STATUS          PORTS
helper    Up 12 seconds
web       Up 12 seconds   0.0.0.0:9090->80/tcp
$ docker compose logs --tail 6 helper                 # helper → web 서비스 이름으로 통신
helper-1  |   <title>My Dev Workstation</title>
$ docker compose exec web printenv APP_ENV
prod
$ docker compose down
```
- **Compose**: 긴 `docker run` 옵션을 YAML 파일로 문서화 → 누구나 `docker compose up` 한 줄로 같은 환경 실행
- **서비스 디스커버리**: 같은 Compose 네트워크 안에서는 IP 대신 서비스 이름(`http://web/`)으로 접근

## 15) 트러블슈팅
### ① git push 시 `403` 오류
- **문제**: `git push -u origin main` 실행 시 `The requested URL returned error: 403`
- **원인 가설**: 저장소는 만들어졌지만, push에 사용한 인증 주체(GitHub App)에 이 저장소의 쓰기 권한이 없다.
- **확인**: GitHub → Settings → Applications → Installed GitHub Apps → Configure 에서 *Repository access* 가 `Only select repositories` 로 다른 저장소 1개만 선택되어 있음을 확인
- **해결**: `dev-workstation` 저장소를 추가 선택 후 Save → 재시도하니 `* [new branch] main -> main` 으로 push 성공
- **배운 점**: 403은 "인증은 됐지만 권한이 없다"는 뜻. 토큰/앱 권한 범위(scope)를 먼저 확인한다.

### ② GitHub 설정 저장 시 "What? Your browser did something unexpected" 오류
- **문제**: 앱 내장 브라우저 창에서 저장소 검색이 계속 로딩되고, Save 시 오류 페이지 표시
- **원인 가설**: 내장 브라우저가 GitHub 보안 요청(쿠키/CSRF 토큰)을 정상 처리하지 못함
- **확인**: 같은 URL(`github.com/settings/installations/...`)을 일반 Chrome에서 열어 비교 → 정상 동작
- **해결**: 일반 Chrome에서 설정 변경 및 저장 완료
- **배운 점**: 같은 요청이 환경에 따라 다르게 동작하면, 환경(브라우저/확장 프로그램)을 바꿔 원인 범위를 좁힌다.

### ③ 스크립트 실행 시 `docker: command not found`
- **문제**: `bash scripts/collect_evidence.sh` 실행 결과, Docker 관련 명령이 모두 `docker: command not found`
- **원인 가설**: Docker Desktop 설치 전에 열어 둔 Git Bash 창이라 PATH에 Docker 경로가 반영되지 않았거나, Docker Desktop이 아직 실행되지 않음
- **확인**: 같은 창에서 `docker --version` 실패 → Docker Desktop 실행(Engine running) 후 Git Bash를 새로 열어 `docker --version` 재확인
- **해결**: 새 터미널에서 스크립트 재실행
- **배운 점**: 프로그램 설치 후에는 터미널을 새로 열어야 환경 변수(PATH)가 갱신된다.

### ④ Windows에서 `chmod` 가 반영되지 않음
- **문제**: Git Bash에서 `chmod 755 note.txt`, `chmod 700 perm_dir` 실행 후에도 `ls -l` 결과가 그대로
- **원인 가설**: Windows NTFS는 리눅스식 r/w/x 권한 비트를 저장하지 않음
- **확인**: [evidence §3](docs/evidence.md#3-권한-변경-변경-전후) 의 변경 전/후 출력 비교
- **해결/대안**: 리눅스 컨테이너(alpine) 안에서 동일 실험을 수행해 권한 변경을 확인

### ⑤ Docker Desktop 설치 실패: `Virtual Machine Platform` 미활성화
- **문제**: Docker Desktop 설치 시 `Installation failed. One prerequisite is not fulfilled.` (Microsoft Store 설치도 `0x00000001` 오류로 실패)
- **원인 가설**: Docker(WSL 2 백엔드)가 사용하는 Windows 가상화 기능 `Virtual Machine Platform` 이 꺼져 있고, *Per-user* 설치는 관리자 권한이 없어 이를 켤 수 없음
- **확인**: 설치 프로그램 오류 메시지에서 원인 및 두 가지 대안(`wsl --install` 또는 All-users 설치) 확인
- **해결**: 설치 프로그램 재실행 → **All-users installation** 선택(관리자 승인) → `Installation succeeded` → 재부팅
- **배운 점**: 컨테이너는 리눅스 커널 기능을 쓰므로 Windows에서는 가상화(WSL 2) 기반이 먼저 필요하다. 설치 오류 메시지가 해결책을 알려 주는 경우가 많으니 끝까지 읽는다.

### ⑥ Compose 실행 시 `port is already allocated`
- **문제**: `docker compose up -d --build` → `Bind for 0.0.0.0:8080 failed: port is already allocated`
- **원인 가설**: 앞 단계에서 띄운 `my-web-8080` 컨테이너가 호스트 8080 포트를 이미 점유 중
- **확인**: `docker ps` 에서 `0.0.0.0:8080->80/tcp my-web-8080` 확인 ([evidence §8](docs/evidence.md#8-포트-매핑-2회))
- **해결**: 환경 변수로 호스트 포트만 변경 `WEB_PORT=9090 APP_ENV=prod docker compose up -d` → `curl localhost:9090` 응답, `printenv APP_ENV` = `prod` 확인 ([evidence §13](docs/evidence.md#13-보너스-docker-compose))
- **배운 점**: 호스트 포트는 하나의 프로세스만 점유할 수 있다. 포트를 코드가 아닌 환경 변수로 빼 두면 충돌 시 설정만 바꿔 해결할 수 있다.

### (참고) Windows Git Bash 경로 변환
- Git Bash는 `/data` 같은 경로를 `C:/Program Files/Git/data` 로 자동 변환해 `docker exec`·`-v` 가 실패할 수 있다.
- `export MSYS_NO_PATHCONV=1` 및 `cygpath -m` 으로 경로를 지정해 해결 (`collect_evidence.sh` 에 반영).

## 16) 재현 시 주의사항
- 이 결과는 **Windows 11 + Git Bash + Docker Desktop(WSL 2)** 에서 수집했다.
- macOS(서울캠퍼스)에서는 Docker Desktop 대신 **OrbStack** 을 실행한 뒤 같은 명령을 쓰면 된다. 스크립트는 macOS `sed -i ''` 와 Linux/Git Bash `sed -i` 차이를 자동 처리한다.
- Git Bash에서 `docker run -it` 같은 대화형 명령은 `the input device is not a TTY` 오류가 날 수 있다 → PowerShell을 쓰거나 `winpty docker run -it ...` 로 실행한다.
- 바인드 마운트 경로는 PC마다 다르다. 스크립트는 저장소 위치를 자동으로 계산한다(Windows는 `cygpath -m`).
- 포트 8080/8081/8082/9090 이 이미 사용 중이면 `docker ps` 로 확인 후 정리하거나 `WEB_PORT` 로 바꾼다.
