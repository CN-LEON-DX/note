
# pull new docker image
docker pull name

# run docker with name + port
docker run --name new_name -p 7090:80 -d nginx

-- name: name of docker
-p : port mapping
-d : running in background

# docker ps
ubuntu@ip-172-31-1-210:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS         PORTS                                     NAMES
5a251eda1dcb   nginx     "/docker-entrypoint.…"   10 seconds ago   Up 9 seconds   0.0.0.0:7090->80/tcp, [::]:7090->80/tcp   myweb

# stop docker
docker stop id_docker

# restart again
docker start name_docker

# /var/lib/docker/ all config in this folder
root@ip-172-31-1-210:~# cd /var/lib/docker
root@ip-172-31-1-210:/var/lib/docker# ls
buildkit    engine-id  plugins  runtimes  tmp
containers  network    rootfs   swarm     volumes

# check the size of container
cd /container
root@ip-172-31-1-210:/var/lib/docker/containers# du -sh 5a251eda1dcbb27a33fea914e3d9cad7e9e9b9ba849f23675e2aa8c2072fb2d8
44K	5a251eda1dcbb27a33fea914e3d9cad7e9e9b9ba849f23675e2aa8c2072fb2d8

# run CMD in container
docker exec name_image + cmd
EX:
root@ip-172-31-1-210:~# docker exec myweb ls /
bin
boot
dev
docker-entrypoint.d
docker-entrypoint.sh
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

# Access to command