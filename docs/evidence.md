# 수행 로그 (증거)

> `scripts/collect_evidence.sh` 로 자동 수집한 실제 터미널 명령/출력입니다.
> 수집 시각: 2026-11-02 15:56:08    

## 1. 실행 환경

```bash
$ uname -a
MINGW64_NT-10.0-26200 WIN-GUKVVEMLUJV 3.6.10-5a1665c8.x86_64 2026-09-28 10:40 UTC x86_64 Msys
$ cmd.exe /c ver

Microsoft Windows [Version 10.0.26200.9711]
$ echo $SHELL
/usr/bin/bash
$ docker --version
scripts/collect_evidence.sh: line 30: docker: command not found
$ git --version
git version 2.56.0.windows.4
```

## 2. 터미널 기본 조작

```bash
$ pwd
/c/Users/82103/dev-workstation
$ mkdir -p "/c/Users/82103/codyssey/practice" && cd "/c/Users/82103/codyssey/practice" && pwd
/c/Users/82103/codyssey/practice
$ touch empty.txt
$ echo "hello codyssey" > note.txt
$ cat note.txt
hello codyssey
$ cp note.txt note_copy.txt
$ mv note_copy.txt renamed.txt
$ mkdir tmpdir && mv renamed.txt tmpdir/
$ ls -la
total 1
drwxr-xr-x 1 82103 197609  0 Nov  2 15:56 .
drwxr-xr-x 1 82103 197609  0 Nov  2 15:56 ..
-rw-r--r-- 1 82103 197609  0 Nov  2 15:56 empty.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 15:56 note.txt
drwxr-xr-x 1 82103 197609  0 Nov  2 15:56 tmpdir
$ ls -la tmpdir
total 1
drwxr-xr-x 1 82103 197609  0 Nov  2 15:56 .
drwxr-xr-x 1 82103 197609  0 Nov  2 15:56 ..
-rw-r--r-- 1 82103 197609 15 Nov  2 15:56 renamed.txt
$ rm tmpdir/renamed.txt && rmdir tmpdir
$ ls -la
total 1
drwxr-xr-x 1 82103 197609  0 Nov  2 15:56 .
drwxr-xr-x 1 82103 197609  0 Nov  2 15:56 ..
-rw-r--r-- 1 82103 197609  0 Nov  2 15:56 empty.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 15:56 note.txt
$ cd .. && pwd
/c/Users/82103/codyssey
$ ls "/c/Users/82103/codyssey/practice/note.txt"
/c/Users/82103/codyssey/practice/note.txt
```

## 3. 권한 변경 (변경 전/후)

참고: Windows(Git Bash)는 NTFS 특성상 chmod 결과가 제한적으로 반영될 수 있습니다. 이 경우 아래 Docker 컨테이너(Linux) 내 결과를 함께 확인하세요.

```bash
$ ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 15:56 note.txt
$ chmod 755 note.txt && ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 15:56 note.txt
$ chmod 644 note.txt && ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 15:56 note.txt
$ mkdir -p perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 15:56 perm_dir
$ chmod 700 perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 15:56 perm_dir
$ chmod 755 perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 15:56 perm_dir
```
Linux 컨테이너 안에서 동일 실험:

```bash
$ docker run --rm alpine sh -c 'touch f.txt; mkdir d; ls -l f.txt; ls -ld d; chmod 755 f.txt; chmod 700 d; echo "--- after ---"; ls -l f.txt; ls -ld d'
scripts/collect_evidence.sh: line 30: docker: command not found
```

## 4. Docker 설치 및 데몬 점검

```bash
$ docker --version
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker info
scripts/collect_evidence.sh: line 30: docker: command not found
```

## 5. hello-world / ubuntu

```bash
$ docker run hello-world
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker pull ubuntu
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker run --rm ubuntu bash -c "ls && echo inside container"
scripts/collect_evidence.sh: line 30: docker: command not found
```

## 6. attach vs exec 관찰

```bash
$ docker run -dit --name my-ubuntu ubuntu bash
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker exec my-ubuntu bash -c "echo exec로 새 프로세스 실행 && ps aux"
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker ps --filter name=my-ubuntu
scripts/collect_evidence.sh: line 30: docker: command not found
```
exec 로 실행한 프로세스가 끝나도 컨테이너는 Up 상태 유지. 반면 `docker attach my-ubuntu` 후 `exit` 하면 메인 프로세스(bash)가 종료되어 컨테이너도 Exited 로 바뀐다 (빠져나오기만 하려면 Ctrl+P, Ctrl+Q).

```bash
$ docker stop my-ubuntu && docker ps -a --filter name=my-ubuntu
scripts/collect_evidence.sh: line 30: docker: command not found
```

## 7. Dockerfile 커스텀 이미지 빌드

```bash
$ cat Dockerfile
# 베이스: 공식 NGINX 경량 이미지 (방식 A: 웹 서버 베이스 + 정적 콘텐츠 교체)
FROM nginx:alpine

# 커스텀 포인트 1: 이미지 메타데이터 (이미지 식별/관리 용도)
LABEL org.opencontainers.image.title="my-custom-nginx" \
      org.opencontainers.image.description="Codyssey dev workstation mission"

# 커스텀 포인트 2: 환경 변수 (설정과 코드 분리 연습)
ENV APP_ENV=dev

# 커스텀 포인트 3: 기본 페이지를 내 정적 콘텐츠로 교체
COPY app/ /usr/share/nginx/html/

# 커스텀 포인트 4: 헬스체크 (컨테이너가 정상 응답 중인지 Docker가 주기적으로 확인)
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost/ >/dev/null || exit 1

EXPOSE 80
$ docker build -t my-web:1.0 .
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker images
scripts/collect_evidence.sh: line 30: docker: command not found
```

## 8. 포트 매핑 (2회)

```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
scripts/collect_evidence.sh: line 30: docker: command not found
$ curl -s http://localhost:8080 | grep -E "h1|Version"
$ curl -s http://localhost:8081 | grep -E "h1|Version"
$ docker ps
scripts/collect_evidence.sh: line 30: docker: command not found
```

## 9. Docker 운영 명령

```bash
$ docker ps -a
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker logs my-web-8080
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker stats --no-stream
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker inspect --format "{{.State.Health.Status}}" my-web-8080
scripts/collect_evidence.sh: line 30: docker: command not found
```

## 10. 바인드 마운트 반영 (호스트 변경 전/후)

```bash
$ docker run -d -p 8082:80 --name my-web-bind -v "C:/Users/82103/dev-workstation/app:/usr/share/nginx/html" my-web:1.0
scripts/collect_evidence.sh: line 30: docker: command not found
$ curl -s http://localhost:8082 | grep Version
$ (호스트에서 app/index.html 의 v1 → v2 수정)
$ curl -s http://localhost:8082 | grep Version
```

## 11. Docker 볼륨 영속성 (컨테이너 삭제 전/후)

```bash
$ docker volume create mydata
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker exec vol-test bash -c "echo persistent-data > /data/hello.txt && cat /data/hello.txt"
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker rm -f vol-test
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker exec vol-test2 cat /data/hello.txt
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker volume inspect mydata
scripts/collect_evidence.sh: line 30: docker: command not found
```

## 12. Git 설정

```bash
$ git config --list --show-origin | grep -E "user\.|init\.|remote\.|branch\."
file:C:/Program Files/Git/etc/gitconfig	init.defaultbranch=main
file:C:/Users/82103/.gitconfig	user.name=최영진
file:C:/Users/82103/.gitconfig	user.email=****@****
file:C:/Users/82103/.gitconfig	init.defaultbranch=main
file:.git/config	remote.origin.url=https://github.com/17lucky71/dev-workstation.git
file:.git/config	remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
file:.git/config	branch.main.remote=origin
file:.git/config	branch.main.merge=refs/heads/main
$ git remote -v
origin	https://github.com/17lucky71/dev-workstation.git (fetch)
origin	https://github.com/17lucky71/dev-workstation.git (push)
$ git log --oneline -5
89846a2 docs: 트러블슈팅 추가 (docker PATH, Windows chmod)
93dcc7c add evidence logs
2d82b56 feat: Windows 원클릭 실행 파일 추가
75ad040 feat: 증거 로그 자동 수집 스크립트, 트러블슈팅 작성
a58844c init: 개발 워크스테이션 스타터 파일
```

## 13. (보너스) Docker Compose

```bash
$ docker compose up -d --build
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker compose ps
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker compose logs --tail 10 helper
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker compose down
scripts/collect_evidence.sh: line 30: docker: command not found
$ WEB_PORT=9090 APP_ENV=prod docker compose up -d
scripts/collect_evidence.sh: line 30: docker: command not found
$ curl -s http://localhost:9090 | grep h1
$ docker compose exec web printenv APP_ENV
scripts/collect_evidence.sh: line 30: docker: command not found
$ docker compose down
scripts/collect_evidence.sh: line 30: docker: command not found
```
