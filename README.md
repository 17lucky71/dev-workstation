# 개발 워크스테이션 구축 (Codyssey 입학연수 · 개발 입문)

> `<!-- 붙여넣기 -->` 표시된 곳에 **본인 터미널의 실제 출력**을 붙여 넣으세요.
> 토큰·비밀번호·이메일 등 민감정보는 `****` 로 마스킹합니다.

## 0) 프로젝트 개요
터미널·Docker·Git을 직접 세팅하고, NGINX 기반 커스텀 이미지를 만들어 포트 매핑, 바인드 마운트, 볼륨 영속성을 검증한다. 누가 실행해도 같은 결과가 나오는 **재현 가능한 실행 환경**을 만드는 것이 목표다.

## 1) 실행 환경
| 항목 | 값 |
|---|---|
| OS | macOS <!-- sw_vers 결과 --> |
| Shell / Terminal | zsh / Terminal.app (또는 iTerm2) |
| Container Runtime | OrbStack (sudo 없이 Docker 엔진 제공) |
| Docker | <!-- docker --version --> |
| Git | <!-- git --version --> |

## 2) 수행 체크리스트
- [ ] 터미널 기본 조작 및 폴더 구성
- [ ] 권한 변경 실습 (파일 1, 디렉토리 1)
- [ ] Docker 설치/점검 (`--version`, `info`)
- [ ] Docker 운영 명령 (`images`, `ps -a`, `logs`, `stats`)
- [ ] hello-world / ubuntu 컨테이너 실행
- [ ] Dockerfile 커스텀 이미지 빌드/실행
- [ ] 포트 매핑 접속 (2회)
- [ ] 바인드 마운트 반영
- [ ] 볼륨 영속성
- [ ] Git 설정 + VSCode GitHub 연동
- [ ] (보너스) Docker Compose / 환경 변수 / SSH 키

## 3) 저장소 구조
```
.
├── app/index.html        # 웹 서버 정적 콘텐츠
├── Dockerfile            # nginx:alpine 기반 커스텀 이미지
├── docker-compose.yml    # (보너스) web + helper
├── docs/screenshots/     # 브라우저/VSCode 캡처
└── README.md
```

---

## 4) 터미널 조작 로그
```bash
$ pwd
<!-- 붙여넣기 -->
$ mkdir -p ~/codyssey/practice && cd ~/codyssey/practice
$ touch empty.txt                # 빈 파일 생성
$ echo "hello" > note.txt
$ cat note.txt                   # 파일 내용 확인
$ cp note.txt note_copy.txt      # 복사
$ mv note_copy.txt renamed.txt   # 이동/이름변경
$ mkdir tmpdir && mv renamed.txt tmpdir/
$ ls -la                         # 숨김 파일 포함 목록
<!-- 붙여넣기 -->
$ rm tmpdir/renamed.txt && rmdir tmpdir   # 삭제
$ ls -la
<!-- 붙여넣기 -->
```

**절대 경로 vs 상대 경로**
- 절대 경로: 루트(`/`)부터 시작 → `/Users/me/codyssey/practice/note.txt`
- 상대 경로: 현재 위치 기준 → `./note.txt`, `../practice/note.txt`

## 5) 권한 실습
```bash
$ ls -l note.txt
<!-- 변경 전 -->
$ chmod 755 note.txt
$ ls -l note.txt
<!-- 변경 후 -->

$ mkdir perm_dir && ls -ld perm_dir
<!-- 변경 전 -->
$ chmod 700 perm_dir
$ ls -ld perm_dir
<!-- 변경 후 -->
```
**해석 규칙**: r=4, w=2, x=1을 더해 소유자/그룹/기타 순서로 표기
- `755` = rwx r-x r-x (소유자 전체, 나머지 읽기·실행)
- `644` = rw- r-- r-- (소유자 읽기·쓰기, 나머지 읽기)
- 디렉토리의 `x` = 그 안으로 들어갈(cd) 수 있는 권한

## 6) Docker 설치 및 점검
```bash
$ docker --version
<!-- 붙여넣기 -->
$ docker info | head -n 20
<!-- 붙여넣기 (Server 섹션이 보이면 데몬 동작 중) -->
```

## 7) 컨테이너 실행 실습
```bash
$ docker run hello-world
<!-- 붙여넣기 -->

$ docker pull ubuntu
$ docker run -it --name my-ubuntu ubuntu bash
root@xxxx:/# ls
root@xxxx:/# echo "inside container"
root@xxxx:/# exit
<!-- 붙여넣기 -->

$ docker start my-ubuntu
$ docker exec -it my-ubuntu bash   # 새 셸로 진입
$ exit                             # 컨테이너는 계속 실행됨
$ docker attach my-ubuntu          # 메인 프로세스(bash)에 붙음
$ exit                             # 메인 프로세스 종료 → 컨테이너도 종료
$ docker ps -a
<!-- 붙여넣기 -->
```
**attach vs exec 관찰**: `exec`는 별도 프로세스를 띄우므로 빠져나와도 컨테이너가 유지되고, `attach`는 메인 프로세스에 직접 연결되므로 `exit` 시 컨테이너가 종료된다. (attach 상태에서 종료 없이 빠지려면 `Ctrl+P, Ctrl+Q`)

## 8) Docker 운영 명령
```bash
$ docker images
$ docker ps
$ docker ps -a
$ docker logs my-web-8080
$ docker stats --no-stream
$ docker stop my-web-8080 && docker ps -a
<!-- 붙여넣기 -->
```

## 9) 커스텀 이미지 (Dockerfile)
- **베이스**: `nginx:alpine` (방식 A: 웹 서버 베이스 + 정적 콘텐츠 교체)

| 커스텀 포인트 | 목적 |
|---|---|
| `LABEL` | 이미지 이름/설명 메타데이터로 식별 용이 |
| `ENV APP_ENV=dev` | 실행 모드를 코드 밖 설정으로 분리 |
| `COPY app/` | 기본 NGINX 페이지를 내 콘텐츠로 교체 |
| `HEALTHCHECK` | 컨테이너 정상 응답 여부 자동 점검 |

```bash
$ docker build -t my-web:1.0 .
<!-- 붙여넣기 -->
```

## 10) 포트 매핑 및 접속
```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
$ curl http://localhost:8080
$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
$ curl http://localhost:8081
<!-- 붙여넣기 -->
```
![8080 접속](docs/screenshots/port-8080.png)
![8081 접속](docs/screenshots/port-8081.png)

**포트 매핑이 필요한 이유**: 컨테이너는 격리된 네트워크를 가지므로, 호스트 포트(8080)를 컨테이너 포트(80)에 연결해야 외부(브라우저)에서 접근할 수 있다. 호스트 포트만 바꾸면 같은 이미지를 여러 개 동시에 띄울 수 있다.

## 11) 바인드 마운트 반영
```bash
$ docker run -d -p 8082:80 --name my-web-bind \
    -v "$(pwd)/app:/usr/share/nginx/html" my-web:1.0
$ curl -s http://localhost:8082 | grep Version
<!-- 변경 전: v1 -->
$ sed -i '' 's/v1/v2/' app/index.html     # 호스트에서 파일 수정
$ curl -s http://localhost:8082 | grep Version
<!-- 변경 후: v2 (재빌드 없이 반영) -->
```

## 12) Docker 볼륨 영속성
```bash
$ docker volume create mydata
$ docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity
$ docker exec vol-test bash -c "echo persistent > /data/hello.txt && cat /data/hello.txt"
$ docker rm -f vol-test
$ docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
$ docker exec vol-test2 cat /data/hello.txt
<!-- 붙여넣기: 컨테이너를 지워도 persistent 가 그대로 출력 -->
$ docker volume inspect mydata
```
**볼륨이란**: 컨테이너 생명주기와 분리되어 Docker가 관리하는 저장 공간. 컨테이너를 삭제해도 데이터가 남는다.

## 13) Git 설정 및 GitHub 연동
```bash
$ git config --global user.name "내이름"
$ git config --global user.email "****@****.com"
$ git config --global init.defaultBranch main
$ git config --list
<!-- 붙여넣기 (이메일 마스킹) -->
```
![VSCode GitHub 연동](docs/screenshots/vscode-github.png)

**Git vs GitHub**: Git은 내 컴퓨터에서 변경 이력을 관리하는 **로컬 버전관리 도구**, GitHub는 Git 저장소를 원격에 올려 공유·리뷰·협업하는 **플랫폼**이다.

## 14) 트러블슈팅
### ① <!-- 예: docker: command not found -->
- **문제**:
- **원인 가설**: OrbStack 앱이 실행되지 않아 Docker 엔진이 꺼져 있음
- **확인**: `docker info` 결과 / OrbStack 상태
- **해결/대안**:

### ② <!-- 예: port is already allocated -->
- **문제**:
- **원인 가설**: 같은 호스트 포트를 이미 다른 컨테이너가 사용 중
- **확인**: `docker ps`, `lsof -i :8080`
- **해결/대안**: 기존 컨테이너 중지 또는 다른 호스트 포트 사용

## 15) (보너스) Docker Compose
```bash
$ docker compose up -d --build
$ docker compose ps
$ docker compose logs helper     # web 서비스와 통신되는지 확인
$ WEB_PORT=9090 docker compose up -d   # 환경 변수로 포트 변경
$ docker compose down
<!-- 붙여넣기 -->
```

## 16) 재현 시 주의사항
- macOS `sed -i ''` 는 Linux에서 `sed -i` 로 바꿔 실행
- sudo 권한이 없는 환경은 OrbStack(또는 Docker Desktop)을 먼저 실행한 뒤 진행
