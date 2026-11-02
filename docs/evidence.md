# 수행 로그 (증거)

> `scripts/collect_evidence.sh` 로 자동 수집한 실제 터미널 명령/출력입니다.
> 수집 시각: 2026-11-02 16:53:44    

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
drwxr-xr-x 1 82103 197609  0 Nov  2 16:53 .
drwxr-xr-x 1 82103 197609  0 Nov  2 16:53 ..
-rw-r--r-- 1 82103 197609  0 Nov  2 16:53 empty.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:53 note.txt
drwxr-xr-x 1 82103 197609  0 Nov  2 16:53 tmpdir
$ ls -la tmpdir
total 1
drwxr-xr-x 1 82103 197609  0 Nov  2 16:53 .
drwxr-xr-x 1 82103 197609  0 Nov  2 16:53 ..
-rw-r--r-- 1 82103 197609 15 Nov  2 16:53 renamed.txt
$ rm tmpdir/renamed.txt && rmdir tmpdir
$ ls -la
total 1
drwxr-xr-x 1 82103 197609  0 Nov  2 16:53 .
drwxr-xr-x 1 82103 197609  0 Nov  2 16:53 ..
-rw-r--r-- 1 82103 197609  0 Nov  2 16:53 empty.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:53 note.txt
$ cd .. && pwd
/c/Users/82103/codyssey
$ ls "/c/Users/82103/codyssey/practice/note.txt"
/c/Users/82103/codyssey/practice/note.txt
```

## 3. 권한 변경 (변경 전/후)

참고: Windows(Git Bash)는 NTFS 특성상 chmod 결과가 제한적으로 반영될 수 있습니다. 이 경우 아래 Docker 컨테이너(Linux) 내 결과를 함께 확인하세요.

```bash
$ ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:53 note.txt
$ chmod 755 note.txt && ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:53 note.txt
$ chmod 644 note.txt && ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:53 note.txt
$ mkdir -p perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 16:53 perm_dir
$ chmod 700 perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 16:53 perm_dir
$ chmod 755 perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 16:53 perm_dir
```
Linux 컨테이너 안에서 동일 실험:

```bash
$ docker run --rm alpine sh -c 'touch f.txt; mkdir d; ls -l f.txt; ls -ld d; chmod 755 f.txt; chmod 700 d; echo "--- after ---"; ls -l f.txt; ls -ld d'
-rw-r--r--    1 root     root             0 Nov  2 07:53 f.txt
drwxr-xr-x    2 root     root          4096 Nov  2 07:53 d
--- after ---
-rwxr-xr-x    1 root     root             0 Nov  2 07:53 f.txt
drwx------    2 root     root          4096 Nov  2 07:53 d
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
 Containers: 1
  Running: 0
  Paused: 0
  Stopped: 1
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
7c2fc605d172
$ docker ps -a --filter name=ubuntu-test --format "{{.Names}}  {{.Status}}"
ubuntu-test  Exited (0) Less than a second ago
```
**exec**: 실행 중인 컨테이너에 *새 프로세스*를 추가로 띄운다. exec 셸을 exit 해도 메인 프로세스(bash, PID 1)는 그대로라 컨테이너가 유지된다.

```bash
$ docker rm -f my-ubuntu >/dev/null 2>&1; docker run -di --name my-ubuntu ubuntu bash
ee6e5782d3323cac3f39005862948dab82f54766af5d8ef21816e471b3311432
$ printf "echo inside via exec; ps -o pid,cmd; exit\n" | docker exec -i my-ubuntu bash
inside via exec
    PID CMD
      1 bash
      7 bash
     13 ps -o pid,cmd
$ docker ps --filter name=my-ubuntu --format "{{.Names}}  {{.Status}}"
my-ubuntu  Up Less than a second
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
$ docker build -t my-web:1.0 .
#0 building with "desktop-linux" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 813B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/nginx:alpine
#2 DONE 1.6s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [internal] load build context
#4 transferring context: 596B done
#4 DONE 0.0s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 resolve docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606 0.0s done
#5 DONE 0.0s

#6 [2/2] COPY app/ /usr/share/nginx/html/
#6 CACHED

#7 exporting to image
#7 exporting layers done
#7 exporting manifest sha256:7b961b9cf221d82f8ee6d598418d166284ca18714aaff3180dab00958e9da064 done
#7 exporting config sha256:25ae48d4708540b2e855bafe28bd40f0bd6447bf3544d732b65c574ba6fee87b done
#7 exporting attestation manifest sha256:d1a904884931d064755216d5893ae61460c927cc0d283327668ea35e7788e6c7 0.0s done
#7 exporting manifest list sha256:e3391dfda803677c652b899692697e746126bd8dfca2ef34a1c451ed6f69b491 done
#7 naming to docker.io/library/my-web:1.0 done
#7 unpacking to docker.io/library/my-web:1.0 done
#7 DONE 0.1s
$ docker images
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:latest        be2656061b53         13MB         3.94MB        
hello-world:latest   c567b231f656       25.9kB         9.49kB   U    
my-web:1.0           e3391dfda803       93.6MB         26.3MB        
ubuntu:latest        6a06111c3b0a        163MB         45.9MB   U    
```

## 8. 포트 매핑 (2회)

```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
f043cc3ff18e5706f86567bbb93e98560308cdd200a446e1af4bd983581811de
$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
f61d8e38d1cdae58843f973e69d63585d0e71fce3e4cbf7b3505e5a6b771a493
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
f61d8e38d1cd   my-web:1.0   "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds (health: starting)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   my-web-8081
f043cc3ff18e   my-web:1.0   "/docker-entrypoint.…"   3 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-web-8080
```

## 9. Docker 운영 명령

```bash
$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                   CREATED          STATUS                            PORTS                                     NAMES
f61d8e38d1cd   my-web:1.0    "/docker-entrypoint.…"   3 seconds ago    Up 2 seconds (health: starting)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   my-web-8081
f043cc3ff18e   my-web:1.0    "/docker-entrypoint.…"   3 seconds ago    Up 3 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-web-8080
ee6e5782d332   ubuntu        "bash"                    12 seconds ago   Exited (137) 6 seconds ago                                                  my-ubuntu
7c2fc605d172   ubuntu        "bash"                    13 seconds ago   Exited (0) 13 seconds ago                                                   ubuntu-test
72cd6d5f79fe   hello-world   "/hello"                  16 seconds ago   Exited (0) 16 seconds ago                                                   ecstatic_franklin
b13384a6a672   hello-world   "/hello"                  19 minutes ago   Exited (0) 19 minutes ago                                                   laughing_heyrovsky
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
2026/11/02 07:54:01 [notice] 1#1: using the "epoll" event method
2026/11/02 07:54:01 [notice] 1#1: nginx/1.31.8
2026/11/02 07:54:01 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
2026/11/02 07:54:01 [notice] 1#1: OS: Linux 6.18.54.1-microsoft-standard-WSL2
2026/11/02 07:54:01 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2026/11/02 07:54:01 [notice] 1#1: start worker processes
2026/11/02 07:54:01 [notice] 1#1: start worker process 30
2026/11/02 07:54:01 [notice] 1#1: start worker process 31
2026/11/02 07:54:01 [notice] 1#1: start worker process 32
2026/11/02 07:54:01 [notice] 1#1: start worker process 33
2026/11/02 07:54:01 [notice] 1#1: start worker process 34
2026/11/02 07:54:01 [notice] 1#1: start worker process 35
2026/11/02 07:54:01 [notice] 1#1: start worker process 36
2026/11/02 07:54:01 [notice] 1#1: start worker process 37
2026/11/02 07:54:01 [notice] 1#1: start worker process 38
2026/11/02 07:54:01 [notice] 1#1: start worker process 39
2026/11/02 07:54:01 [notice] 1#1: start worker process 40
2026/11/02 07:54:01 [notice] 1#1: start worker process 41
172.17.0.1 - - [02/Nov/2026:07:54:04 +0000] "GET / HTTP/1.1" 200 526 "-" "curl/8.23.0" "-"
$ docker stats --no-stream
CONTAINER ID   NAME          CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O         PIDS
f61d8e38d1cd   my-web-8081   0.00%     11.78MiB / 7.612GiB   0.15%     1.74kB / 1.27kB   0B / 8.19kB       13
f043cc3ff18e   my-web-8080   0.00%     12.11MiB / 7.612GiB   0.16%     1.93kB / 1.27kB   4.33MB / 12.3kB   13
$ docker inspect --format "{{.State.Health.Status}}" my-web-8080
starting
```

## 10. 바인드 마운트 반영 (호스트 변경 전/후)

```bash
$ docker run -d -p 8082:80 --name my-web-bind -v "C:/Users/82103/dev-workstation/app:/usr/share/nginx/html" my-web:1.0
eedc5d896e25757e5c9f23883dee165749aa5e0178fb379c4a594be27731c32f
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
842cb6b6b2212280f57c122a80f6206d61c343d00658b1b9bbd7549d1580228c
$ docker exec vol-test bash -c "echo persistent-data > /data/hello.txt && cat /data/hello.txt"
persistent-data
$ docker rm -f vol-test
vol-test
$ docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
cfe5f793a40ab789d1122e9d130d8291477ff7291cb9fd6368e94d630794e555
$ docker exec vol-test2 cat /data/hello.txt
persistent-data
$ docker volume inspect mydata
[
    {
        "CreatedAt": "2026-11-02T07:54:10Z",
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
4290bcd feat: ubuntu 내부 진입, attach/exec 비교 자동 실습 추가
ed4b052 docs: VSCode GitHub 연동 스크린샷, 체크리스트 완료
ce11f1a docs: 8081 포트 접속 스크린샷
b87145a docs: 8080 포트 접속 스크린샷
47b3589 docs: 실행 환경/검증 요약/트러블슈팅 반영
```

## 13. (보너스) Docker Compose

```bash
$ docker compose up -d --build
 Image my-web:1.0 Building 
#1 [internal] load local bake definitions
#1 reading from stdin 514B 0.0s done
#1 DONE 0.0s

#2 [internal] load build definition from Dockerfile
#2 transferring dockerfile: 813B 0.0s done
#2 DONE 0.0s

#3 [internal] load metadata for docker.io/library/nginx:alpine
#3 DONE 0.4s

#4 [internal] load .dockerignore
#4 transferring context: 2B done
#4 DONE 0.0s

#5 [internal] load build context
#5 transferring context: 596B done
#5 DONE 0.0s

#6 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#6 resolve docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606 0.0s done
#6 DONE 0.0s

#7 [2/2] COPY app/ /usr/share/nginx/html/
#7 CACHED

#8 exporting to image
#8 exporting layers done
#8 exporting manifest sha256:42ccce365682497f975063f8b93c4f5fe2a1b0fb1ebb39cc77e0091e89bb0173 done
#8 exporting config sha256:be018ab0195a9eb057d2a7107723c43c193aee28ed143663bb89bbed3d59dd20 done
#8 exporting attestation manifest sha256:68b2c2a81a89dfbd01a8b862061b80b11c26712f076a9b51ece4d3eab868b3f1 0.0s done
#8 exporting manifest list sha256:1713c671d420efa79e6f11491de8ac9042f52064e1bc734bd32eb65664944d8c 0.0s done
#8 naming to docker.io/library/my-web:1.0
#8 naming to docker.io/library/my-web:1.0 done
#8 unpacking to docker.io/library/my-web:1.0 done
#8 DONE 0.1s

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
Error response from daemon: failed to set up container networking: driver failed programming external connectivity on endpoint dev-workstation-web-1 (e6630d92786c8ff2fdae3f59c1dcba86c6d3289fb7787a11405fd96ff84d3113): Bind for 0.0.0.0:8080 failed: port is already allocated
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
dev-workstation-helper-1   alpine       "sh -c 'while true; …"   helper    13 seconds ago   Up 12 seconds                      
dev-workstation-web-1      my-web:1.0   "/docker-entrypoint.…"   web       13 seconds ago   Up 12 seconds (health: starting)   0.0.0.0:9090->80/tcp, [::]:9090->80/tcp
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
