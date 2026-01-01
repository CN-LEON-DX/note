
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

