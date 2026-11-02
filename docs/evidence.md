# 수행 로그 (증거)

> `scripts/collect_evidence.sh` 로 자동 수집한 실제 터미널 명령/출력입니다.
> 수집 시각: 2026-11-02 16:34:18    

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
drwxr-xr-x 1 82103 197609  0 Nov  2 16:34 .
drwxr-xr-x 1 82103 197609  0 Nov  2 16:34 ..
-rw-r--r-- 1 82103 197609  0 Nov  2 16:34 empty.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:34 note.txt
drwxr-xr-x 1 82103 197609  0 Nov  2 16:34 tmpdir
$ ls -la tmpdir
total 1
drwxr-xr-x 1 82103 197609  0 Nov  2 16:34 .
drwxr-xr-x 1 82103 197609  0 Nov  2 16:34 ..
-rw-r--r-- 1 82103 197609 15 Nov  2 16:34 renamed.txt
$ rm tmpdir/renamed.txt && rmdir tmpdir
$ ls -la
total 1
drwxr-xr-x 1 82103 197609  0 Nov  2 16:34 .
drwxr-xr-x 1 82103 197609  0 Nov  2 16:34 ..
-rw-r--r-- 1 82103 197609  0 Nov  2 16:34 empty.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:34 note.txt
$ cd .. && pwd
/c/Users/82103/codyssey
$ ls "/c/Users/82103/codyssey/practice/note.txt"
/c/Users/82103/codyssey/practice/note.txt
```

## 3. 권한 변경 (변경 전/후)

참고: Windows(Git Bash)는 NTFS 특성상 chmod 결과가 제한적으로 반영될 수 있습니다. 이 경우 아래 Docker 컨테이너(Linux) 내 결과를 함께 확인하세요.

```bash
$ ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:34 note.txt
$ chmod 755 note.txt && ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:34 note.txt
$ chmod 644 note.txt && ls -l note.txt
-rw-r--r-- 1 82103 197609 15 Nov  2 16:34 note.txt
$ mkdir -p perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 16:34 perm_dir
$ chmod 700 perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 16:34 perm_dir
$ chmod 755 perm_dir && ls -ld perm_dir
drwxr-xr-x 1 82103 197609 0 Nov  2 16:34 perm_dir
```
Linux 컨테이너 안에서 동일 실험:

```bash
$ docker run --rm alpine sh -c 'touch f.txt; mkdir d; ls -l f.txt; ls -ld d; chmod 755 f.txt; chmod 700 d; echo "--- after ---"; ls -l f.txt; ls -ld d'
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
7b229517ed22: Pulling fs layer
3ec36f3670df: Download complete
3da1513d2124: Download complete
7b229517ed22: Download complete
7b229517ed22: Pull complete
Digest: sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a
Status: Downloaded newer image for alpine:latest
-rw-r--r--    1 root     root             0 Nov  2 07:34 f.txt
drwxr-xr-x    2 root     root          4096 Nov  2 07:34 d
--- after ---
-rwxr-xr-x    1 root     root             0 Nov  2 07:34 f.txt
drwx------    2 root     root          4096 Nov  2 07:34 d
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
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 1
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
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pulling fs layer
4f55086f7dd0: Download complete
4f55086f7dd0: Pull complete
d5e71e642bf5: Download complete
Digest: sha256:c567b231f65614688711a75f31518a064258a51d442117a3e771a3a8fdba78ef
Status: Downloaded newer image for hello-world:latest

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
f3f25b84a7d7: Pulling fs layer
edafa32f5d9e: Pulling fs layer
f3f25b84a7d7: Download complete
21594acc2d8b: Download complete
edafa32f5d9e: Download complete
f3f25b84a7d7: Pull complete
edafa32f5d9e: Pull complete
Digest: sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c
Status: Downloaded newer image for ubuntu:latest
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

## 6. attach vs exec 관찰

```bash
$ docker run -dit --name my-ubuntu ubuntu bash
ff06dfda0b0833be29ebe468f9c6fb1c5d393010ebbda5c648c66b51d5daf456
$ docker exec my-ubuntu bash -c "echo exec로 새 프로세스 실행 && ps aux"
exec로 새 프로세스 실행
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  4.3  0.0   4776  4148 pts/0    Ss+  07:34   0:00 bash
root           8 50.0  0.0   6760  4048 ?        Rs   07:34   0:00 ps aux
$ docker ps --filter name=my-ubuntu
CONTAINER ID   IMAGE     COMMAND   CREATED        STATUS        PORTS     NAMES
ff06dfda0b08   ubuntu    "bash"    1 second ago   Up 1 second             my-ubuntu
```
exec 로 실행한 프로세스가 끝나도 컨테이너는 Up 상태 유지. 반면 `docker attach my-ubuntu` 후 `exit` 하면 메인 프로세스(bash)가 종료되어 컨테이너도 Exited 로 바뀐다 (빠져나오기만 하려면 Ctrl+P, Ctrl+Q).

```bash
$ docker stop my-ubuntu && docker ps -a --filter name=my-ubuntu
my-ubuntu
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS                                PORTS     NAMES
ff06dfda0b08   ubuntu    "bash"    6 seconds ago   Exited (137) Less than a second ago             my-ubuntu
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
#1 transferring dockerfile: 813B 0.0s done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/nginx:alpine
#2 DONE 2.8s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [internal] load build context
#4 transferring context: 596B 0.0s done
#4 DONE 0.1s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 resolve docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606 0.0s done
#5 DONE 0.2s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 extracting sha256:7b229517ed222597277036d94892173207d01a731ab3a88eeb1de2e963a2c788
#5 extracting sha256:7b229517ed222597277036d94892173207d01a731ab3a88eeb1de2e963a2c788 0.2s done
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 0B / 20.53MB 0.3s
#5 sha256:9b0f7dfe35b2711a17f60dadd6d4035dc0cdee152538cc5c0987029e94679548 0B / 1.40kB 0.2s
#5 sha256:2ec5fb117ffa9a78b15fb6a78745ffc569c8da0aee9f36ace4cd67a44b1fef79 0B / 1.21kB 0.2s
#5 sha256:26185d08a3ec318dd85a6c9f2172e714ec13cececd7f33c533b40b1689f9fedb 0B / 404B 0.2s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 2.10MB / 20.53MB 0.8s
#5 sha256:9b0f7dfe35b2711a17f60dadd6d4035dc0cdee152538cc5c0987029e94679548 1.40kB / 1.40kB 0.6s done
#5 sha256:2ec5fb117ffa9a78b15fb6a78745ffc569c8da0aee9f36ace4cd67a44b1fef79 1.21kB / 1.21kB 0.8s done
#5 sha256:7cc330898115ce55acccb0cc1e7dd091df4410c8c5f3c540710ee0ac689f5fcb 0B / 964B 0.2s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 3.15MB / 20.53MB 0.9s
#5 sha256:26185d08a3ec318dd85a6c9f2172e714ec13cececd7f33c533b40b1689f9fedb 404B / 404B 0.9s done
#5 sha256:7cc330898115ce55acccb0cc1e7dd091df4410c8c5f3c540710ee0ac689f5fcb 964B / 964B 0.3s done
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 5.24MB / 20.53MB 1.1s
#5 sha256:657023555a2a19dc6036468198bb350d2c7feaac7f2d0a3901b4dd3cb25e40c5 0B / 629B 0.2s
#5 sha256:12b85cff06fd7d383d36a9c96503fe049c9d4bf3dfda5cbb9ffa6ae99b9c07a6 0B / 1.94MB 0.2s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 6.29MB / 20.53MB 1.2s
#5 sha256:657023555a2a19dc6036468198bb350d2c7feaac7f2d0a3901b4dd3cb25e40c5 629B / 629B 0.3s done
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 8.39MB / 20.53MB 1.4s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 9.44MB / 20.53MB 1.5s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 11.53MB / 20.53MB 1.7s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 12.58MB / 20.53MB 1.8s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 13.63MB / 20.53MB 2.0s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 14.68MB / 20.53MB 2.1s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 16.78MB / 20.53MB 2.3s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 17.83MB / 20.53MB 2.4s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 18.87MB / 20.53MB 2.6s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 20.53MB / 20.53MB 2.6s done
#5 sha256:12b85cff06fd7d383d36a9c96503fe049c9d4bf3dfda5cbb9ffa6ae99b9c07a6 1.05MB / 1.94MB 1.8s
#5 sha256:12b85cff06fd7d383d36a9c96503fe049c9d4bf3dfda5cbb9ffa6ae99b9c07a6 1.94MB / 1.94MB 2.3s done
#5 DONE 3.5s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 extracting sha256:12b85cff06fd7d383d36a9c96503fe049c9d4bf3dfda5cbb9ffa6ae99b9c07a6
#5 extracting sha256:12b85cff06fd7d383d36a9c96503fe049c9d4bf3dfda5cbb9ffa6ae99b9c07a6 0.2s done
#5 extracting sha256:657023555a2a19dc6036468198bb350d2c7feaac7f2d0a3901b4dd3cb25e40c5
#5 extracting sha256:657023555a2a19dc6036468198bb350d2c7feaac7f2d0a3901b4dd3cb25e40c5 0.0s done
#5 extracting sha256:7cc330898115ce55acccb0cc1e7dd091df4410c8c5f3c540710ee0ac689f5fcb 0.0s done
#5 extracting sha256:26185d08a3ec318dd85a6c9f2172e714ec13cececd7f33c533b40b1689f9fedb 0.0s done
#5 extracting sha256:2ec5fb117ffa9a78b15fb6a78745ffc569c8da0aee9f36ace4cd67a44b1fef79 0.0s done
#5 extracting sha256:9b0f7dfe35b2711a17f60dadd6d4035dc0cdee152538cc5c0987029e94679548 0.0s done
#5 extracting sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919
#5 extracting sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 0.6s done
#5 DONE 4.3s

#6 [2/2] COPY app/ /usr/share/nginx/html/
#6 DONE 0.1s

#7 exporting to image
#7 exporting layers 0.1s done
#7 exporting manifest sha256:7b961b9cf221d82f8ee6d598418d166284ca18714aaff3180dab00958e9da064 0.0s done
#7 exporting config sha256:25ae48d4708540b2e855bafe28bd40f0bd6447bf3544d732b65c574ba6fee87b 0.0s done
#7 exporting attestation manifest sha256:2c7b2aa37072788ac318d39927d251b01c22174b99f7ec8d1b230382a70ada2c 0.0s done
#7 exporting manifest list sha256:34e155f2c1724ec272a5b836c61ac86f34224bf00d36baf493279efab9a4528d 0.0s done
#7 naming to docker.io/library/my-web:1.0 done
#7 unpacking to docker.io/library/my-web:1.0
#7 unpacking to docker.io/library/my-web:1.0 0.8s done
#7 DONE 1.0s
$ docker images
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:latest        be2656061b53         13MB         3.94MB        
hello-world:latest   c567b231f656       25.9kB         9.49kB   U    
my-web:1.0           34e155f2c172       93.6MB         26.3MB        
ubuntu:latest        6a06111c3b0a        163MB         45.9MB   U    
```

## 8. 포트 매핑 (2회)

```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
faad7c12a9c0b375ac6a541014101d0a194290bb086a4e44adfa0ce1589b2412
$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
040bb4befa9ad52099c738a6613724ca4e82d38522239459f6a9f76c5c414193
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
040bb4befa9a   my-web:1.0   "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds (health: starting)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   my-web-8081
faad7c12a9c0   my-web:1.0   "/docker-entrypoint.…"   4 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-web-8080
```

## 9. Docker 운영 명령

```bash
$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                   CREATED          STATUS                            PORTS                                     NAMES
040bb4befa9a   my-web:1.0    "/docker-entrypoint.…"   3 seconds ago    Up 3 seconds (health: starting)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   my-web-8081
faad7c12a9c0   my-web:1.0    "/docker-entrypoint.…"   4 seconds ago    Up 4 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-web-8080
ff06dfda0b08   ubuntu        "bash"                    21 seconds ago   Exited (137) 16 seconds ago                                                 my-ubuntu
b13384a6a672   hello-world   "/hello"                  34 seconds ago   Exited (0) 33 seconds ago                                                   laughing_heyrovsky
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
2026/11/02 07:35:05 [notice] 1#1: using the "epoll" event method
2026/11/02 07:35:05 [notice] 1#1: nginx/1.31.8
2026/11/02 07:35:05 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
2026/11/02 07:35:05 [notice] 1#1: OS: Linux 6.18.54.1-microsoft-standard-WSL2
2026/11/02 07:35:05 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2026/11/02 07:35:05 [notice] 1#1: start worker processes
2026/11/02 07:35:05 [notice] 1#1: start worker process 30
2026/11/02 07:35:05 [notice] 1#1: start worker process 31
2026/11/02 07:35:05 [notice] 1#1: start worker process 32
2026/11/02 07:35:05 [notice] 1#1: start worker process 33
2026/11/02 07:35:05 [notice] 1#1: start worker process 34
2026/11/02 07:35:05 [notice] 1#1: start worker process 35
2026/11/02 07:35:05 [notice] 1#1: start worker process 36
2026/11/02 07:35:05 [notice] 1#1: start worker process 37
2026/11/02 07:35:05 [notice] 1#1: start worker process 38
2026/11/02 07:35:05 [notice] 1#1: start worker process 39
2026/11/02 07:35:05 [notice] 1#1: start worker process 40
2026/11/02 07:35:05 [notice] 1#1: start worker process 41
172.17.0.1 - - [02/Nov/2026:07:35:08 +0000] "GET / HTTP/1.1" 200 526 "-" "curl/8.23.0" "-"
$ docker stats --no-stream
CONTAINER ID   NAME          CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O     PIDS
040bb4befa9a   my-web-8081   0.00%     11.01MiB / 7.612GiB   0.14%     1.59kB / 1.27kB   0B / 8.19kB   13
faad7c12a9c0   my-web-8080   0.00%     11.75MiB / 7.612GiB   0.15%     1.93kB / 1.27kB   0B / 12.3kB   13
$ docker inspect --format "{{.State.Health.Status}}" my-web-8080
starting
```

## 10. 바인드 마운트 반영 (호스트 변경 전/후)

```bash
$ docker run -d -p 8082:80 --name my-web-bind -v "C:/Users/82103/dev-workstation/app:/usr/share/nginx/html" my-web:1.0
705b599fb3b015b4902d6db5b7a45c1289f8cfc701abf048fb0c1ee5ba3cc276
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
a19c1e70b6ab9280bdafc126ff117d29d92fa070c65cbee384ca80897075b9fc
$ docker exec vol-test bash -c "echo persistent-data > /data/hello.txt && cat /data/hello.txt"
persistent-data
$ docker rm -f vol-test
vol-test
$ docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
d6e5727182dc1c4a0b1d0e4c1fcccc924c0ebc845adef1cb5377a1dd27b2f0c6
$ docker exec vol-test2 cat /data/hello.txt
persistent-data
$ docker volume inspect mydata
[
    {
        "CreatedAt": "2026-11-02T07:35:16Z",
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
$ git remote -v
origin	https://github.com/17lucky71/dev-workstation.git (fetch)
origin	https://github.com/17lucky71/dev-workstation.git (push)
$ git log --oneline -5
a147481 docs: 트러블슈팅 추가 (Docker 설치 VMP 오류)
70bd447 evidence: docker logs
89846a2 docs: 트러블슈팅 추가 (docker PATH, Windows chmod)
93dcc7c add evidence logs
2d82b56 feat: Windows 원클릭 실행 파일 추가
```

## 13. (보너스) Docker Compose

```bash
$ docker compose up -d --build
 Image my-web:1.0 Building 
#1 [internal] load local bake definitions
#1 reading from stdin 514B 0.1s done
#1 DONE 0.1s

#2 [internal] load build definition from Dockerfile
#2 transferring dockerfile: 813B 0.0s done
#2 DONE 0.0s

#3 [internal] load metadata for docker.io/library/nginx:alpine
#3 DONE 0.5s

#4 [internal] load .dockerignore
#4 transferring context: 2B done
#4 DONE 0.0s

#5 [internal] load build context
#5 transferring context: 596B 0.0s done
#5 DONE 0.0s

#6 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#6 resolve docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606 0.0s done
#6 DONE 0.0s

#7 [2/2] COPY app/ /usr/share/nginx/html/
#7 CACHED

#8 exporting to image
#8 exporting layers done
#8 exporting manifest sha256:42ccce365682497f975063f8b93c4f5fe2a1b0fb1ebb39cc77e0091e89bb0173 0.0s done
#8 exporting config sha256:be018ab0195a9eb057d2a7107723c43c193aee28ed143663bb89bbed3d59dd20
#8 exporting config sha256:be018ab0195a9eb057d2a7107723c43c193aee28ed143663bb89bbed3d59dd20 0.0s done
#8 exporting attestation manifest sha256:1e7ec73cb9df45ac05c75ea853d1b0fb1ef7a199378b7897fe6d70a545dcc99b 0.0s done
#8 exporting manifest list sha256:fc19bd207466c55f94997cd8fcd5e184a0797e0b3a9c508940a6a9df3049da8e 0.0s done
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
Error response from daemon: failed to set up container networking: driver failed programming external connectivity on endpoint dev-workstation-web-1 (98f4fbe9a10c651a5800218f28e14dbbb8048f6139d5e38c81859792b7317fc7): Bind for 0.0.0.0:8080 failed: port is already allocated
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
