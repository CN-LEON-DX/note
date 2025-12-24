You need to set up to run IN Jenkins:
- AWS:
    + IAM USER with ACCESS Keys
    + ECR Registry
    + ECS
- iNSTALL:
    - Plugin:
        docker
        docker pipeline
        ECR
        ECS
        AWS SDK
- Jenkins:
    - Store: aws access key (credential - at least privileges)
    - Docker engine
    - AWS CLI
1. Install docker engine in Jenkins -> add jenkins user to -> docker group @ reboot
2. Install AWS CLI
3. IAM user
4. ECR repo
5. Plugins ;((
6. Running on ECS

### CMD:
- Setup docker:
   ```bash
   sudo apt update
   sudo snap install aws-cli
   sudo snap install aws-cli --classic
  
    sudo apt update
    sudo apt install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc 
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
    Types: deb
    URIs: https://download.docker.com/linux/ubuntu
    Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
    Components: stable
    Signed-By: /etc/apt/keyrings/docker.asc
    EOF

   sudo apt update
   sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   sudo systemctl status docker
   sudo docker run hello-world
   ```
- Switch to Jenkins user -> test run docker permission -> add Jenkins user -> to Group docker
    ```bash
    root@ip-172-31-21-24:~# su - jenkins
    jenkins@ip-172-31-21-24:~$ docker images
    permission denied while trying to connect to the docker API at unix:///var/run/docker.sock
    jenkins@ip-172-31-21-24:~$ exit
    logout
    root@ip-172-31-21-24:~# usermod -a -G docker jenkins 
    root@ip-172-31-21-24:~# id jenkins
    uid=111(jenkins) gid=113(jenkins) groups=113(jenkins),988(docker)
    root@ip-172-31-21-24:~# 
    ```
  
- Create ECS cluster + service (task run)
- run file Jenkins and configs
- You want to Clean project -> Go to service -> change -> 'desired tassk' to -> 0 first 
- Then delete service 