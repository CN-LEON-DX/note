### 1. SETUP ANSIBLE 

- Create 4 EC2 instance:
    + 1 for ansible server for control
    + 2 for host web
    + 1 for database
- Make sure 3 other EC2 allow control server ssh to with Allow SG
- Install Ansible on Ubuntu:
```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

- Make file inventory and test connect private with in the private network
```bash
ubuntu@ip-172-31-0-175:~/project/sample1$ chmod 400 clientkey.pem 
ubuntu@ip-172-31-0-175:~/project/sample1$ ansible web01 -m ping -i inventory
[WARNING]: Host 'web01' is using the discovered Python interpreter at '/usr/bin/python3.9', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.19/reference_appendices/interpreter_discovery.html for more information.
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.9"
    },
    "changed": false,
    "ping": "pong"
}
ubuntu@ip-172-31-0-175:~/project/sample1$ cat inventory 
all:
    hosts:
        web01:
            ansible_host: 172.31.12.193 # private ip here
            ansible_user: ec2-user
            ansible_ssh_private_key_file: clientkey.pem	
ubuntu@ip-172-31-0-175:~/project/sample1$ 
```
- make group of service:
```bash
all:
    hosts:
        web01:
            ansible_host: 172.31.12.193
        web02:
            ansible_host: 172.31.10.103
        db01:
            ansible_host: 172.31.1.89
    children:
        webservers:
            hosts:
                web01:
                web02:
        dbservers:
            hosts:
                db01:
        dc_oregon:
            children:
                webservers:
                dbservers:
            vars:
                ansible_user: ec2-user
                ansible_ssh_private_key_file: clientkey.pem
```
- Add new file _ansible.cfg_ to override default config
```bash
[defaults]
host_key_checking = False

[ssh_connection]
ssh_args = -C -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```
- Test all connection:
```bash
ansible all -m ping -i inventory
```
- Ad-hoc command (you need to pass --become to ensure it have sudo privilege:
```bash
ubuntu@ip-172-31-0-175:~/project/sample1$ ansible web01 -m ansible.builtin.yum -a "name=httpd state=present" -i inventory --become
[WARNING]: Host 'web01' is using the discovered Python interpreter at '/usr/bin/python3.9', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.19/reference_appendices/interpreter_discovery.html for more information.
web01 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.9"
    },
    "changed": true,
    "msg": "",
    "rc": 0,
    "results": [
        "Installed: httpd-2.4.62-10.el9.x86_64",
        "Installed: mod_http2-2.0.26-5.el9.x86_64",
        "Installed: httpd-core-2.4.62-10.el9.x86_64",
        "Installed: apr-util-openssl-1.6.1-23.el9.x86_64",
        "Installed: httpd-filesystem-2.4.62-10.el9.noarch",
        "Installed: apr-1.7.0-12.el9.x86_64",
        "Installed: mod_lua-2.4.62-10.el9.x86_64",
        "Installed: httpd-tools-2.4.62-10.el9.x86_64",
        "Installed: apr-util-1.6.1-23.el9.x86_64",
        "Installed: centos-logos-httpd-90.8-3.el9.noarch",
        "Installed: apr-util-bdb-1.6.1-23.el9.x86_64"
    ]
}

```
- You also can run adhoc command for Groups if server is download this package -> in the same state -> it won't take any changes to your Server
- It called -> Idempotent 

- Adhoc with service builtin
```bash
ubuntu@ip-172-31-0-175:~/project/sample1$ ansible webservers -m ansible.builtin.service -a "name=httpd state=started enabled=yes" -i inventory --become
```

- Copy file to the server this should look like this:
```bash
ubuntu@ip-172-31-0-175:~/project/sample1$ ansible webservers -m ansible.builtin.copy -a "src=index.html dest=/var/www/html/index.html" -i inventory --become
[WARNING]: Host 'web02' is using the discovered Python interpreter at '/usr/bin/python3.9', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.19/reference_appendices/interpreter_discovery.html for more information.
web02 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.9"
    },
    "changed": true,
    "checksum": "ef873ffe0ec1208695f0359ea3c533c0e87497f0",
    "dest": "/var/www/html/index.html",
    "gid": 0,
    "group": "root",
    "md5sum": "6650678b89084f1181003e9f5458c3cf",
    "mode": "0644",
    "owner": "root",
    "secontext": "system_u:object_r:httpd_sys_content_t:s0",
    "size": 24,
    "src": "/home/ec2-user/.ansible/tmp/ansible-tmp-1766739507.1789527-17189-165133459605552/.source.html",
    "state": "file",
    "uid": 0
}
```

### 2. Playbook

- written in YAML format
- Collections of play - task?
- Play example:
```bash
- hosts:
  tasks:
  - name: install apahe
    yum:
      name: httpd
      state: lastest
  - name: deploy config
    copy:
      src: file/httpd.conf
      dest: /etc/httpd.conf
- host:
  tasks:
    ...
```
- Playbook:
  - List of host
  - List of task
  - Each task have:
    - Name module
    - options module

- Playbook run:
```bash
ansible-playbook -i inventory web-db.yaml
ansible-playbook -i inventory web-db.yaml -vansible-playbook -i inventory web-db.yaml -v
```
- You can run either -v or more -vvv for more detail logs
- Check SYNTAX:
```bash
ubuntu@ip-172-31-0-175:~/project/sample1$ ansible-playbook -i inventory web-db.yaml --syntax-check
playbook: web-db.yaml
```
- DRY-RUN check mode (like experiment) - close to actual run but - maybe it fail in dry run -> maybe it run in actual-run ;(:
```bash
ansible-playbook -i inventory web-db.yaml -C
```

- CREATE NEW DB in MYSQL (you can get error like this):
```bash
ubuntu@ip-172-31-0-175:~/project/sample3$ ansible-playbook -i inventory db.yaml 
[ERROR]: Task failed: Module failed: A MySQL module is required: for Python 2.7 either PyMySQL, or MySQL-python, or for Python 3.X mysqlclient or PyMySQL. Consider setting ansible_python_interpreter to use the intended Python version.
Origin: /home/ubuntu/project/sample3/db.yaml:15:7

13         state: started
14         enabled: yes
15     - name: create new database 'accounts'
         ^ column 7

fatal: [db01]: FAILED! => {"changed": false, "msg": "A MySQL module is required: for Python 2.7 either PyMySQL, or MySQL-python, or for Python 3.X mysqlclient or PyMySQL. Consider setting ansible_python_interpreter to use the intended Python version."}

PLAY RECAP ***********************************************************************************************************************************************************************************
db01                       : ok=3    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

```

- Let install python3-PyMySQL to fix this:
```bash
---
- name: DB server setup
  hosts: dbservers
  become: yes
  tasks:
    - name: install maria db server
      ansible.builtin.yum:
        name: mariadb-server
        state: present
    - name: install python for exec cmd database python3-PyMySQL # add new
      ansible.builtin.yum:
        name: python3-PyMySQL  # fix here 
        state: present
    - name: start service
      ansible.builtin.service:
        name: mariadb
        state: started
        enabled: yes
    - name: create new database 'accounts'
      mysql_db:
        name: accounts
        state: present
```

- But you still get:
```bash
TASK [create new database 'accounts'] ********************************************************************************************************************************************************
[ERROR]: Task failed: Module failed: unable to find /root/.my.cnf. Exception message: (1698, "Access denied for user 'root'@'localhost'")
Origin: /home/ubuntu/project/sample3/db.yaml:19:7

17         state: started
18         enabled: yes
19     - name: create new database 'accounts'
         ^ column 7

fatal: [db01]: FAILED! => {"changed": false, "msg": "unable to find /root/.my.cnf. Exception message: (1698, \"Access denied for user 'root'@'localhost'\")"}

PLAY RECAP ***********************************************************************************************************************************************************************************
db01                       : ok=4    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
```

- => So you can fix with add new agr: login_unix_socket: **_/var/lib/mysql/mysql.sock_** when create db

### 3. Community Module

- You can use some community module for custom use 
- Instead of using  mysql_db normal -> we use => community.mysql.mysql_db:
- But you have to install it before run:
```bash
ansible-galaxy collection install community.mysql
```

### 4. Ansible Configuration

- when you want to using specific config for variable, ...
- you can override it by default ANSIBLE_CONFIG
- The file **_ansible.cfg_** (you put in current directory, same with inventory)

- **The order of ansible config (precedence order):**
  - 1 - ANSIBLE_CONFIG - env var if set
  - 2 - ansible.cfg (curr dir)
  - 3 - ~/.ansible/cfg (in the home dir)
  - 4 - /ect/ansible/ansible.cfg 

- You can check which file is used with (_ansible --version_) or (*ansible-config dump --only-changed*):
```bash
ubuntu@ip-172-31-0-175:~/project/sample3$ ansible --version
ansible [core 2.19.5]
  config file = /home/ubuntu/project/sample3/ansible.cfg
  configured module search path = ['/home/ubuntu/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/ubuntu/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.12.3 (main, Nov  6 2025, 13:44:16) [GCC 13.3.0] (/usr/bin/python3)
  jinja version = 3.1.2
  pyyaml version = 6.0.1 (with libyaml v0.2.5)
```

- After that -> you just using like this to execute: 
```bash
ubuntu@ip-172-31-0-175:~/project/sample3$ ansible-playbook db.yaml 
[WARNING]: log file at '/var/log/ansible.log' is not writeable and we cannot create it, aborting
...
PLAY RECAP *********************************************************************
db01                       : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

- But you can see the file log here but you need to aDD:
```bash
sudo touch /var/log/ansible.log
sudo chown ubuntu:ubuntu /var/log/ansible.log
```