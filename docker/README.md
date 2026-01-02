
### 1. pull new docker image
* docker pull name

### 2. run docker with name + port
* docker run --name new_name -p 7090:80 -d nginx
* 
* -- name: name of docker
* -p : port mapping
* -d : running in background

### 3. docker ps
* ubuntu@ip-172-31-1-210:~$ docker ps
* CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS         PORTS                                     NAMES
* 5a251eda1dcb   nginx     "/docker-entrypoint.…"   10 seconds ago   Up 9 seconds   0.0.0.0:7090->80/tcp, [::]:7090->80/tcp   myweb
* 
### 4. stop docker
* docker stop id_docker

### 5. restart again
* docker start name_docker

### /var/lib/docker/ all config in this folder
1. root@ip-172-31-1-210:~# cd /var/lib/docker
2. root@ip-172-31-1-210:/var/lib/docker# ls
3. buildkit    engine-id  plugins  runtimes  tmp
4. containers  network    rootfs   swarm     volumes

### 6. check the size of container
* cd /container
* root@ip-172-31-1-210:/var/lib/docker/containers# du -sh 5a251eda1dcbb27a33fea914e3d9cad7e9e9b9ba849f23675e2aa8c2072fb2d8
* 44K	5a251eda1dcbb27a33fea914e3d9cad7e9e9b9ba849f23675e2aa8c2072fb2d8
* 
### 7. run CMD in container
* docker exec name_image + cmd
* EX:
* root@ip-172-31-1-210:~# docker exec myweb ls /
* bin
* boot
* dev
* docker-entrypoint.d
* docker-entrypoint.sh
* etc
* home
* lib
* lib64
* media
* mnt
* opt
* proc
* root
* run
* sbin
* srv
* sys
* tmp
* usr
* var

### 8. Access to command in container
- docker exec -it your_name_container /bin/bash

- Install the ps by apt install procps
- Process in container 
```bash
root@5a251eda1dcb:/# ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 10:46 ?        00:00:00 nginx: master process ngi
nginx         22       1  0 10:46 ?        00:00:00 nginx: worker process
nginx         23       1  0 10:46 ?        00:00:00 nginx: worker process
root          31       0  0 11:04 pts/0    00:00:00 /bin/bash
root         161      31  0 11:08 pts/0    00:00:00 ps -ef
root@5a251eda1dcb:/# 
****
```

### 9. Remove image
- docker stop + name
- docker rmi + name

### 10. container logs
- docker logs container_name

### 11. container data VOLUME

- USING BIND MOUNT
- managed by docker (/var/lib/docker/volumes/ on linux)
```bash
docker run --name my_db \
  -d \
  -e MYSQL_ROOT_PASSWORD=secretpass \
  -p 3030:3006 \
  -v /me/ubuntu/data:/var/lib/mysql \
  mysql:6.4
```
- -e for environment var 
- -p for port
- -v for where volume is mapping

```bash
root@ip-172-31-75-62:~#  docker run --name mydb -d -e MYSQL_ROOT_PASSWORD=secretpass -p 3030:3306 -v /home/ubuntu/dbdata:/var/lib/mysql mysql:5.7
05804c9b89c543c2b8b439b179081f5066a3d437e6dcfd82775d632602ead14b
root@ip-172-31-75-62:~# 
```

- USING DOCKER VOLUME
```bash
docker volume create mydbdata
docker volume ls

ubuntu@ip-172-31-75-62:~/dbdata$ docker volume ls
DRIVER    VOLUME NAME
local     mydbdata
ubuntu@ip-172-31-75-62:~/dbdata$  docker run --name mydb -d -e MYSQL_ROOT_PASSWORD=secretpass -p 3030:3306 -v mydbdata:/var/lib/mysql mysql:5.7
3f3aa5a35d63ecb0cf0204686d017443ddc3c5ff4050f638fb27a0051fdc407a
ubuntu@ip-172-31-75-62:~/dbdata$ 

```

- Try to login to MYSQL with (you can find pass when inspect):
```bash
mysql -h 172.17.0.2 -u root -psecretpass 
```

### 11. How to build docker container = Dockerfile build image

- Idea: Dockerfile => build => Image
- FROM => base image
- LABELS => adds metadata to an image
- RUN => execute commands in a new layer and commit the result
- ADD/COPY => Adds files and folders into image (not recommend using ADD)
- CMD => run binaries/ commands on docker run 
- ENTRYPOINT => allow config a container that will run as executable 
- VOLUME => Create mount point and marks it as holding externally mounted volumes
- EXPOSE => Container listens on the specified network port at runtime
- ENV => set env vars
- USER => set user name of UID
- WORKDIR => set working directory
- ARG => Define a var that users can pass at build time 
- ONBUILD => Adds to the image a trigger instruction 

```bash
ubuntu@ip-172-31-75-62:~/senery$ cat Dockerfile 
FROM ubuntu:latest
LABEL "Author"="Fuzzyfox"

LABEL "Project"="nano"
RUN apt update && apt install git -y
RUN apt install apache2 -y

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /var/www/html

VOLUME /var/log/apache2
ADD web.tar.gz /var/www/html
# COPY senery.tar.gz /var/www/html
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80

```

- Let write docker file in folder have:
```bash
ubuntu@ip-172-31-75-62:~/senery$ ls
'ABOUT THIS TEMPLATE.txt'   Dockerfile   images   index.html   tooplate-living-parallax.css   tooplate-living-scripts.js   web.tar.gz
ubuntu@ip-172-31-75-62:~/senery$ 
```
- The template web: https://www.tooplate.com/view/2150-living-parallax
- And you simply download with: wget https://www.tooplate.com/zip-templates/2150_living_parallax.zip
- Install unzip: sudo apt install unzip -y

### 12. Login docker hub + push image

- Login with: docker login
- Then build with correct name start with your name account + (image = name repos)
```bash
ubuntu@ip-172-31-75-62:~/senery$ docker images
                                                                                                                                                         i Info →   U  In Use
IMAGE                  ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest     d4aaab6242e0       25.9kB         9.52kB    U   
memmes12/fuzzyfox:v1   b3a60701e01e        412MB          119MB    U   
mysql:5.7              4bc6bc963e6d        700MB          149MB    U   
webimg:latest          ae357d552614        412MB          119MB    U   
ubuntu@ip-172-31-75-62:~/senery$ docker push memmes12/fuzzyfox:v1
The push refers to repository [docker.io/memmes12/fuzzyfox]
efe099af539c: Pushed 
4f4fb700ef54: Pushed 
881fae0af82f: Pushed 
d5365502fd2a: Pushed 
20043066d3d5: Pushed 
cb9f5dab45ac: Pushed 
v1: digest: sha256:b3a60701e01ea7c56ba9194b2d6a80645e53bd3746d4fbd493f7f0db284617aa size: 856
ubuntu@ip-172-31-75-62:~/senery$ 
```

### 13. Entrypoint + cmd

- Entrypoint is where you run the main execution 
- And cmd will give the args to this command entrypoint want 
- This value is default to entrypoint 
- But you can override it when run with 

- Assume:
```bash
ENTRYPOINT ["python3"]
CMD ["app.py"]
```

- How it work ?
  1. when you run docker run 
  2. it execute: python3 app.py
  3. But: if you run: docker run myimg script2.py
  4. It would take: _python3 script2.py_ instead of above 

### 14. Docker compose 

- Docker Compose is a tool for defining and running multi-container applications.
- Why use Compose:
  - Simplified control: Define and manage multi-container apps in one YAML file
  -  Compose caches the configuration used to create a container
  - Portability across environments: Compose supports variables in the Compose file

- Install
```bash
sudo apt-get update
sudo apt-get install docker-compose-plugin
docker compose version
```

- Setup basic:
```bash
ubuntu@ip-172-31-75-62:~/composetest$ ls
Dockerfile  app.py  docker-compose.yml  requirements.txt
ubuntu@ip-172-31-75-62:~/composetest$ cat Dockerfile 
# syntax=docker/dockerfile:1
FROM python:3.10-alpine
WORKDIR /code
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 5000
COPY . .
CMD ["flask", "run", "--debug"]
ubuntu@ip-172-31-75-62:~/composetest$ cat docker-compose.yml 
services:
  web:
    build: .
    ports:
      - "8000:5000"
  redis:
    image: "redis:alpine"
    
ubuntu@ip-172-31-75-62:~/composetest$ cat app.py 
import time

import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def hello():
    count = get_hit_count()
    return f'Hello World! I have been seen {count} times.\n'
ubuntu@ip-172-31-75-62:~/composetest$ 
```

- It will build:
  - 2 container 
  - 2 image is pull or build
  - 1 network

- You can check how them can interactive with each other:
```bash
docker network ls

ubuntu@ip-172-31-75-62:~/composetest$ docker network ls
NETWORK ID     NAME                  DRIVER    SCOPE
180eb8baad13   bridge                bridge    local
17970de23e26   composetest_default   bridge    local
70e20bae80af   host                  host      local
e605edb6af7c   none                  null      local
ubuntu@ip-172-31-75-62:~/composetest$ docker network inspect composetest_default 
[
    {
        "Name": "composetest_default",
        "Id": "17970de23e260edfddd8c7555d35a854ea2a03f8d5d674b5a45e040e31d85439",
        "Created": "2026-01-01T18:23:37.936140886Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv4": true,
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "IPRange": "",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Options": {},
        "Labels": {
            "com.docker.compose.config-hash": "e07bb132f0f22f78727c72dfefb6a7f493a29b4eea46146efa19df6fe2170d4c",
            "com.docker.compose.network": "default",
            "com.docker.compose.project": "composetest",
            "com.docker.compose.version": "5.0.0"
        },
        "Containers": {
            "5328b62867642bda88e00fed4c28a4ef8e30bbd3a2ff5045f766faa47b9bcaa0": {
                "Name": "composetest-redis-1",
                "EndpointID": "f784950b9160f3a2c34d19847466eb296c5f6d8b0a295822eccf1c344dacc3c3",
                "MacAddress": "ba:45:ad:6d:02:6e",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            },
            "af03b2c36d446d2eb7c10346a67553550ba23997fd451171f6ada0caf933c40e": {
                "Name": "composetest-web-1",
                "EndpointID": "8dc03499bcfaa7b3dc66d4a76d6e420c8b5a2a6aae1678614bef24247151fc81",
                "MacAddress": "d2:6c:75:26:e0:4d",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            }
        },
        "Status": {
            "IPAM": {
                "Subnets": {
                    "172.18.0.0/16": {
                        "IPsInUse": 5,
                        "DynamicIPsAvailable": 65531
                    }
                }
            }
        }
    }
]
```

- Setup docker watch:
```bash
ubuntu@ip-172-31-75-62:~/composetest$ cat docker-compose.yml 
services:
  web:
    build: .
    ports:
      - "8000:5000"
    
    volumes:
      - "8000:5000"
    environment:
      FLASK_ENV: development
    develop:
      watch:
        - action: sync
          path: .
          target: /code
  redis:
    image: "redis:alpine"

```

- You can use Watch in DEV environment
- it suitable for some app web run by: Flask, react, frontend web has watch utils support

- SPLIT UP your services:
```bash
include:
   - infra.yaml
```
- You can create a new file service and then include them inside the main docker-compose file

### 15. Multi-stage Dockerfile

- Save time and space when rebuild 
- We will split them into at least 2 stage:
  - Stage 1: Build stage 
  - Stage 2: Runtime stage
  - Stage 3: .. 
- Stage 1: build artifact and reuse later with: FROM ... AS BUILD_IMAGE
- Stage 2: use it with: --from=BUILD_IMAGE