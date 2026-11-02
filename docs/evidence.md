# 수행 로그 (증거)

> `scripts/collect_evidence.sh` 로 자동 수집한 실제 터미널 명령/출력입니다.
> 수집 시각: 2026-11-02 17:25:30    

## 1. 실행 환경

```bash
$ uname -a
MINGW64_NT-10.0-26200 WIN-GUKVVEMLUJV 3.6.10-5a1665c8.x86_64 2026-09-28 10:40 UTC x86_64 Msys
$ cmd.exe /c ver

Microsoft Windows [Version 10.0.26200.9711]
$ echo $SHELL
/usr/bin/bash
$ docker --version
Docker version 29.9.2, build a82e528
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
drwxr-xr-x 1 82103 197609  0 Nov  2 17:25 .
drwxr-xr-x 1 82103 197609  0 Nov  2 17:25 ..
-rw-r--r-- 1 82103 197609  0 Nov  2 17:25 empty.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 17:25 note.txt
drwxr-xr-x 1 82103 197609  0 Nov  2 17:25 tmpdir
$ ls -la tmpdir
total 1
drwxr-xr-x 1 82103 197609  0 Nov  2 17:25 .
drwxr-xr-x 1 82103 197609  0 Nov  2 17:25 ..
-rw-r--r-- 1 82103 197609 15 Nov  2 17:25 renamed.txt
$ rm tmpdir/renamed.txt && rmdir tmpdir
$ ls -la
total 1
drwxr-xr-x 1 82103 197609  0 Nov  2 17:25 .
drwxr-xr-x 1 82103 197609  0 Nov  2 17:25 ..
-rw-r--r-- 1 82103 197609  0 Nov  2 17:25 empty.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 17:25 note.txt
$ cd .. && pwd
/c/Users/82103/codyssey
$ ls "/c/Users/82103/codyssey/practice/note.txt"
/c/Users/82103/codyssey/practice/note.txt
```

## 3. 권한 변경 (변경 전/후)

참고: Windows(Git Bash)는 NTFS 특성상 chmod 결과가 제한적으로 반영될 수 있습니다. 이 경우 아래 Docker 컨테이너(Linux) 내 결과를 함께 확인하세요.

```bash
$ ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 17:25 note.txt
$ chmod 755 note.txt && ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 17:25 note.txt
$ chmod 644 note.txt && ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 17:25 note.txt
$ mkdir -p perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 17:25 perm_dir
$ chmod 700 perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 17:25 perm_dir
$ chmod 755 perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 17:25 perm_dir
```
Linux 컨테이너 안에서 동일 실험:

```bash
$ docker run --rm alpine sh -c 'touch f.txt; mkdir d; ls -l f.txt; ls -ld d; chmod 755 f.txt; chmod 700 d; echo "--- after ---"; ls -l f.txt; ls -ld d'
-rw-r--r--    1 root     root             0 Nov  2 08:25 f.txt
drwxr-xr-x    2 root     root          4096 Nov  2 08:25 d
--- after ---
-rwxr-xr-x    1 root     root             0 Nov  2 08:25 f.txt
drwx------    2 root     root          4096 Nov  2 08:25 d
```

## 4. Docker 설치 및 데몬 점검

```bash
$ docker --version
Docker version 29.9.2, build a82e528
$ docker info
Client:
 Version:    29.9.2
 Context:    desktop-linux
 Debug Mode: false
 Plugins:
  agent: Docker AI Agent Runner (Docker Inc.)
    Version:  v1.152.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-agent.exe
  ai: Docker AI Agent - Ask Gordon (Docker Inc.)
    Version:  v1.33.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-ai.exe
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.38.1
    Path:     C:\Program Files\Docker\cli-plugins\docker-buildx.exe
  compose: Docker Compose (Docker Inc.)
    Version:  v5.6.1
    Path:     C:\Program Files\Docker\cli-plugins\docker-compose.exe
  debug: Get a shell into any image or container (Docker Inc.)
    Version:  0.49.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-debug.exe
  desktop: Docker Desktop commands (Docker Inc.)
    Version:  4.97.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-desktop.exe
  dhi: CLI for managing Docker Hardened Images (Docker Inc.)
    Version:  v0.0.9
    Path:     C:\Program Files\Docker\cli-plugins\docker-dhi.exe
  extension: Manages Docker extensions (Docker Inc.)
    Version:  v0.2.32
    Path:     C:\Program Files\Docker\cli-plugins\docker-extension.exe
  init: Creates Docker-related starter files for your project (Docker Inc.)
    Version:  v1.4.1
    Path:     C:\Program Files\Docker\cli-plugins\docker-init.exe
  mcp: Docker MCP Plugin (Docker Inc.)
    Version:  v0.44.2
    Path:     C:\Program Files\Docker\cli-plugins\docker-mcp.exe
  model: Docker Model Runner (Docker Inc.)
    Version:  v1.2.9
    Path:     C:\Program Files\Docker\cli-plugins\docker-model.exe
  offload: Docker Offload (Docker Inc.)
    Version:  v0.7.21
    Path:     C:\Program Files\Docker\cli-plugins\docker-offload.exe
  pass: Docker Pass Secrets Manager Plugin (beta) (Docker Inc.)
    Version:  v0.3.2
    Path:     C:\Program Files\Docker\cli-plugins\docker-pass.exe
  sandbox: "docker sandbox" is deprecated, use Docker Sandboxes instead (Docker Inc.)
    Version:  v0.13.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-sandbox.exe
  scout: Docker Scout (Docker Inc.)
    Version:  v1.27.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-scout.exe

Server:
 Containers: 2
  Running: 0
  Paused: 0
  Stopped: 2
 Images: 4
 Server Version: 29.9.2
 Storage Driver: overlayfs
  driver-type: io.containerd.snapshotter.v1
 Logging Driver: local
 Cgroup Driver: cgroupfs
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 CDI spec directories:
  /etc/cdi
  /var/run/cdi
 Discovered Devices:
  cdi: docker.com/gpu=webgpu
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 nvidia runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: b7a25261e029d68978bbf290df0a62fc819b3c51
 runc version: v1.5.2-0-g29dd3dc2
 init version: de40ad0
 Security Options:
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 6.18.54.1-microsoft-standard-WSL2
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 12
 Total Memory: 7.612GiB
 Name: docker-desktop
 ID: ff757b2e-e4bc-4b61-9090-ce09affbd046
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 HTTP Proxy: http.docker.internal:3128
 HTTPS Proxy: http.docker.internal:3128
 No Proxy: hubproxy.docker.internal
 Labels:
  com.docker.desktop.address=npipe://\\.\pipe\docker_cli
 Experimental: false
 Insecure Registries:
  hubproxy.docker.internal:5555
  127.0.0.0/8
  ::1/128
 Live Restore Enabled: false
 Firewall Backend: iptables

```

## 5. hello-world / ubuntu

```bash
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

$ docker pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
Digest: sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c
Status: Image is up to date for ubuntu:latest
docker.io/library/ubuntu:latest
$ docker run --rm ubuntu bash -c "ls && echo inside container"
bin
boot
dev
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
inside container
```

## 6. ubuntu 내부 진입 / attach vs exec 관찰

컨테이너의 bash 에 표준입력(-i)으로 명령을 직접 전달해 내부에서 실행한다.

```bash
$ docker rm -f ubuntu-test >/dev/null 2>&1; printf "ls\necho hello from inside container\nhostname\nexit\n" | docker run -i --name ubuntu-test ubuntu bash
bin
boot
dev
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
hello from inside container
d8183bd47a1a
$ docker ps -a --filter name=ubuntu-test --format "{{.Names}}  {{.Status}}"
ubuntu-test  Exited (0) Less than a second ago
```
**exec**: 실행 중인 컨테이너에 *새 프로세스*를 추가로 띄운다. exec 셸을 exit 해도 메인 프로세스(bash, PID 1)는 그대로라 컨테이너가 유지된다.

```bash
$ docker rm -f my-ubuntu >/dev/null 2>&1; docker run -di --name my-ubuntu ubuntu bash
2c40cb2386a607077fa7af3c874f8980da3f819600ad7f3a44dbf9df2ca5b52e
$ printf "echo inside via exec; ps -o pid,cmd; exit\n" | docker exec -i my-ubuntu bash
inside via exec
    PID CMD
      1 bash
      7 bash
     13 ps -o pid,cmd
$ docker ps --filter name=my-ubuntu --format "{{.Names}}  {{.Status}}"
my-ubuntu  Up 1 second
```
**attach**: 컨테이너의 *메인 프로세스(PID 1)* 표준입출력에 직접 연결한다. 여기서 exit 하면 메인 프로세스가 끝나므로 컨테이너도 종료된다.

```bash
$ printf "echo inside via attach; exit\n" | docker attach my-ubuntu
$ docker ps -a --filter name=my-ubuntu --format "{{.Names}}  {{.Status}}"
my-ubuntu  Exited (0) 1 second ago
```
정리: exec 후 exit → **Up 유지**, attach 후 exit → **Exited**. (attach 상태에서 종료 없이 빠져나오려면 Ctrl+P, Ctrl+Q)

```bash
$ docker start my-ubuntu && docker stop my-ubuntu && docker ps -a --filter name=my-ubuntu --format "{{.Names}}  {{.Status}}"
my-ubuntu
my-ubuntu
my-ubuntu  Exited (137) Less than a second ago
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
LABEL org.opencontainers.image.authors="17lucky71"

$ docker build -t my-web:1.0 .
#0 building with "desktop-linux" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 867B 0.0s done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/nginx:alpine
#2 DONE 2.1s

#3 [internal] load .dockerignore
#3 transferring context: 2B 0.0s done
#3 DONE 0.0s

#4 [internal] load build context
#4 transferring context: 586B 0.0s done
#4 DONE 0.0s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 resolve docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606 0.0s done
#5 DONE 0.1s

#6 [2/2] COPY app/ /usr/share/nginx/html/
#6 CACHED

#7 exporting to image
#7 exporting layers done
#7 exporting manifest sha256:bec6439732a2c2b16bdeaee376e21e1faf321b15e35509e7f65990d4044fb910 done
#7 exporting config sha256:5e70a818907897fef51cb3bbdde53ac18cb2a6dd9657e540c54012ca9e0ea3b3 done
#7 exporting attestation manifest sha256:1c06f202e27e3725681c03950dc37e04f8f3fe60c57951bd5e0c6a94b157421f 0.0s done
#7 exporting manifest list sha256:ebed6f3b9ab40c4e6538d9cb45d700d4a90463549922ba00d41c3f55eb0666a9 0.0s done
#7 naming to docker.io/library/my-web:1.0 done
#7 unpacking to docker.io/library/my-web:1.0 0.0s done
#7 DONE 0.1s
$ docker images
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:latest        be2656061b53         13MB         3.94MB        
hello-world:latest   c567b231f656       25.9kB         9.49kB   U    
my-web:1.0           ebed6f3b9ab4       93.6MB         26.3MB        
ubuntu:latest        6a06111c3b0a        163MB         45.9MB   U    
```

## 8. 포트 매핑 (2회)

```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
860702f165435db24170bc67f4373ceda3f11b28d88f74915811ed92ce6d52d2
$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
35e73fd289a6b1c5193d978d1905896540ebecb01bd0df2181081a99a85a79ef
$ curl -s http://localhost:8080 | grep -E "h1|Version"
    h1 { color: #2b6cb0; }
  <h1>Hello from my custom NGINX container!</h1>
  <p>Version: <code>v1</code></p>
$ curl -s http://localhost:8081 | grep -E "h1|Version"
    h1 { color: #2b6cb0; }
  <h1>Hello from my custom NGINX container!</h1>
  <p>Version: <code>v1</code></p>
$ docker ps
CONTAINER ID   IMAGE        COMMAND                   CREATED         STATUS                            PORTS                                     NAMES
35e73fd289a6   my-web:1.0   "/docker-entrypoint.…"   3 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   my-web-8081
860702f16543   my-web:1.0   "/docker-entrypoint.…"   4 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-web-8080
```

## 9. Docker 운영 명령

```bash
$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                   CREATED          STATUS                            PORTS                                     NAMES
35e73fd289a6   my-web:1.0    "/docker-entrypoint.…"   3 seconds ago    Up 3 seconds (health: starting)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   my-web-8081
860702f16543   my-web:1.0    "/docker-entrypoint.…"   4 seconds ago    Up 4 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-web-8080
2c40cb2386a6   ubuntu        "bash"                    17 seconds ago   Exited (137) 9 seconds ago                                                  my-ubuntu
d8183bd47a1a   ubuntu        "bash"                    19 seconds ago   Exited (0) 18 seconds ago                                                   ubuntu-test
1683d4365d1b   hello-world   "/hello"                  24 seconds ago   Exited (0) 24 seconds ago                                                   intelligent_ellis
72cd6d5f79fe   hello-world   "/hello"                  32 minutes ago   Exited (0) 32 minutes ago                                                   ecstatic_franklin
b13384a6a672   hello-world   "/hello"                  51 minutes ago   Exited (0) 51 minutes ago                                                   laughing_heyrovsky
$ docker logs my-web-8080
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2026/11/02 08:25:55 [notice] 1#1: using the "epoll" event method
2026/11/02 08:25:55 [notice] 1#1: nginx/1.31.8
2026/11/02 08:25:55 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
2026/11/02 08:25:55 [notice] 1#1: OS: Linux 6.18.54.1-microsoft-standard-WSL2
2026/11/02 08:25:55 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2026/11/02 08:25:55 [notice] 1#1: start worker processes
2026/11/02 08:25:55 [notice] 1#1: start worker process 30
2026/11/02 08:25:55 [notice] 1#1: start worker process 31
2026/11/02 08:25:55 [notice] 1#1: start worker process 32
2026/11/02 08:25:55 [notice] 1#1: start worker process 33
2026/11/02 08:25:55 [notice] 1#1: start worker process 34
2026/11/02 08:25:55 [notice] 1#1: start worker process 35
2026/11/02 08:25:55 [notice] 1#1: start worker process 36
2026/11/02 08:25:55 [notice] 1#1: start worker process 37
2026/11/02 08:25:55 [notice] 1#1: start worker process 38
2026/11/02 08:25:55 [notice] 1#1: start worker process 39
2026/11/02 08:25:55 [notice] 1#1: start worker process 40
2026/11/02 08:25:55 [notice] 1#1: start worker process 41
172.17.0.1 - - [02/Nov/2026:08:25:58 +0000] "GET / HTTP/1.1" 200 516 "-" "curl/8.23.0" "-"
$ docker stats --no-stream
CONTAINER ID   NAME          CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O         PIDS
35e73fd289a6   my-web-8081   0.00%     11.75MiB / 7.612GiB   0.15%     1.74kB / 1.26kB   0B / 8.19kB       13
860702f16543   my-web-8080   0.00%     12.32MiB / 7.612GiB   0.16%     1.93kB / 1.26kB   4.34MB / 12.3kB   13
$ docker inspect --format "{{.State.Health.Status}}" my-web-8080
starting
```

## 10. 바인드 마운트 반영 (호스트 변경 전/후)

```bash
$ docker run -d -p 8082:80 --name my-web-bind -v "C:/Users/82103/dev-workstation/app:/usr/share/nginx/html" my-web:1.0
a4dc09fa97aa10d9f6b1b2affc18e40b6070ce5040a6f96c23304f294c6984b9
$ curl -s http://localhost:8082 | grep Version
  <p>Version: <code>v1</code></p>
$ (호스트에서 app/index.html 의 v1 → v2 수정)
$ curl -s http://localhost:8082 | grep Version
  <p>Version: <code>v2</code></p>
```

## 11. Docker 볼륨 영속성 (컨테이너 삭제 전/후)

```bash
$ docker volume create mydata
mydata
$ docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity
915bb96d163cd4ef835af620d75905e719b44e3014314c0c34d3c9185cf4137f
$ docker exec vol-test bash -c "echo persistent-data > /data/hello.txt && cat /data/hello.txt"
persistent-data
$ docker rm -f vol-test
vol-test
$ docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
d2991a0521794e48927af0e21e2255219c33ea4e40e4682f9f2e8627755714ad
$ docker exec vol-test2 cat /data/hello.txt
persistent-data
$ docker volume inspect mydata
[
    {
        "CreatedAt": "2026-11-02T08:26:07Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/mydata/_data",
        "Name": "mydata",
        "Options": null,
        "Scope": "local"
    }
]
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
file:.git/config	branch.main.vscode-merge-base=origin/main
$ git remote -v
origin	https://github.com/17lucky71/dev-workstation.git (fetch)
origin	https://github.com/17lucky71/dev-workstation.git (push)
$ git log --oneline -5
1f77d73 docs: 커스텀 포인트 표에 authors LABEL 추가
58da615 feat: Docker/Git 상태 대시보드 + 바탕화면 바로가기
336c76d feat: Dockerfile 작성자 LABEL 추가, 페이지 문구 수정
3a906a5 docs: README를 실제 실행 로그 기준으로 전면 정리
e236757 evidence: rerun
```

## 13. (보너스) Docker Compose

```bash
$ docker compose up -d --build
 Image my-web:1.0 Building 
#1 [internal] load local bake definitions
#1 reading from stdin 514B 0.1s done
#1 DONE 0.1s

#2 [internal] load build definition from Dockerfile
#2 transferring dockerfile: 867B 0.0s done
#2 DONE 0.0s

#3 [internal] load metadata for docker.io/library/nginx:alpine
#3 DONE 0.5s

#4 [internal] load .dockerignore
#4 transferring context: 2B done
#4 DONE 0.0s

#5 [internal] load build context
#5 transferring context: 586B 0.0s done
#5 DONE 0.0s

#6 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#6 resolve docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606 0.0s done
#6 DONE 0.0s

#7 [2/2] COPY app/ /usr/share/nginx/html/
#7 CACHED

#8 exporting to image
#8 exporting layers done
#8 exporting manifest sha256:97b8e4f9532624ab6dd0c6761ef615aebe221091f0c563d399d1eaf9d028e54d 0.0s done
#8 exporting config sha256:dbc8e6bb77b1b9988599d5fec13e24ba72ea79f694464301001642a6668896fe 0.0s done
#8 exporting attestation manifest sha256:e13364ace9141ea9897e2220c3f8eaf87c72a753a67d53f0451995f740be1c04 0.0s done
#8 exporting manifest list sha256:12b102ddccccf9c2dbbbdc83eb6e3c7c1680f6a3e09070da82bff8b2af62b891 0.0s done
#8 naming to docker.io/library/my-web:1.0 done
#8 unpacking to docker.io/library/my-web:1.0 done
#8 DONE 0.2s

#9 resolving provenance for metadata file
#9 DONE 0.0s
 Image my-web:1.0 Built 
 Network dev-workstation_default Creating 
 Network dev-workstation_default Creating 
 Network dev-workstation_default Created 
 Network dev-workstation_default Created 
 Container dev-workstation-web-1 Creating 
 Container dev-workstation-web-1 Created 
 Container dev-workstation-helper-1 Creating 
 Container dev-workstation-helper-1 Created 
 Container dev-workstation-web-1 Starting 
Error response from daemon: failed to set up container networking: driver failed programming external connectivity on endpoint dev-workstation-web-1 (4499b94b0ad03e7afc7d0e1285051fb11f18bd359917581804850668d1e2307f): Bind for 0.0.0.0:8080 failed: port is already allocated
$ docker compose ps
NAME      IMAGE     COMMAND   SERVICE   CREATED   STATUS    PORTS
$ docker compose logs --tail 10 helper
$ docker compose down
 Container dev-workstation-helper-1 Stopping 
 Container dev-workstation-helper-1 Stopped 
 Container dev-workstation-helper-1 Removing 
 Container dev-workstation-helper-1 Removed 
 Container dev-workstation-web-1 Stopping 
 Container dev-workstation-web-1 Stopped 
 Container dev-workstation-web-1 Removing 
 Container dev-workstation-web-1 Removed 
 Network dev-workstation_default Removing 
 Network dev-workstation_default Removed 
$ WEB_PORT=9090 APP_ENV=prod docker compose up -d
 Network dev-workstation_default Creating 
 Network dev-workstation_default Creating 
 Network dev-workstation_default Created 
 Network dev-workstation_default Created 
 Container dev-workstation-web-1 Creating 
 Container dev-workstation-web-1 Created 
 Container dev-workstation-helper-1 Creating 
 Container dev-workstation-helper-1 Created 
 Container dev-workstation-web-1 Starting 
 Container dev-workstation-web-1 Started 
 Container dev-workstation-helper-1 Starting 
 Container dev-workstation-helper-1 Started 
$ curl -s http://localhost:9090 | grep h1
    h1 { color: #2b6cb0; }
  <h1>Hello from my custom NGINX container!</h1>
$ docker compose ps
NAME                       IMAGE        COMMAND                   SERVICE   CREATED          STATUS                             PORTS
dev-workstation-helper-1   alpine       "sh -c 'while true; …"   helper    13 seconds ago   Up 13 seconds                      
dev-workstation-web-1      my-web:1.0   "/docker-entrypoint.…"   web       13 seconds ago   Up 13 seconds (health: starting)   0.0.0.0:9090->80/tcp, [::]:9090->80/tcp
$ docker compose logs --tail 6 helper
helper-1  |   <title>My Dev Workstation</title>
helper-1  | <!DOCTYPE html>
helper-1  | <html lang="ko">
helper-1  | <head>
helper-1  |   <meta charset="UTF-8">
helper-1  |   <title>My Dev Workstation</title>
$ docker compose exec web printenv APP_ENV
prod
$ docker compose down
 Container dev-workstation-helper-1 Stopping 
 Container dev-workstation-helper-1 Stopped 
 Container dev-workstation-helper-1 Removing 
 Container dev-workstation-helper-1 Removed 
 Container dev-workstation-web-1 Stopping 
 Container dev-workstation-web-1 Stopped 
 Container dev-workstation-web-1 Removing 
 Container dev-workstation-web-1 Removed 
 Network dev-workstation_default Removing 
 Network dev-workstation_default Removed 
```
