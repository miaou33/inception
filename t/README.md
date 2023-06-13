# Inception

This project aims to deepen the knowledge of system administration.

Use of dockerfile for the creation and management of custom images, micro services.

Use of docker-compose for the deployment of containers, the creation and management of the network, storage space, etc ...

## Table of contents

- #### [DOCKER](#docker-1)
- #### [STARTER PACK MARIADB - ADMINER ](#starter-pack--mariadb---adminer-)
- #### [PHP-FPM & NGNIX](#php-fpm--ngnix-1)
- #### [LOCAL DOMAINS IN LINUX](#local-domains-in-linux-2)
- #### [SETUP A SELF-SIGNED SSL CERTIFICATE](#setup-a-self-signed-ssl-certificate-1)

# Local Domains in Linux

## Structure of the project with the bonuses

<img src="./.img_readme/DGRB.png">

# DOCKER

## BASIC DOCKER COMMANDS

* ```docker ps -a``` : List active containers (-a is for showing all containers, running and stopped)
* ```docker stop  <id>/<name>``` : Stop running containers
* ```docker start <id>/<name>``` : Start stopped containers
* ```docker rm -f <id>/<name>``` : Remove containers (-f is for force the removal of a running container)
* ```docker exec -it <name> bash``` : Execute a command in a running container


Tips to delete all containers, use: ```docker rm -f $(docker ps -qa)```

## DOCKER RUN

``` bash
$ docker run [OPTIONS] IMAGE[:TAG]
```

| Parameters | Description                       |
| :-------- | :-------------------------------- |
| `-d`      | Run container in background (daemon mode) |
| `-it`      | creating an interactive container |
| `-p`      | Publish a container port(s) to the host |
| `--rm`      | Automatically remove the container when it exits |
| `--hostname`      | Container host name |
| `--name`      |  Assign a name to the container |

#### Exemple 
```
$ docker run -d -ti -p 80:80 --rm --name web-ngnix --hostname nginx-container nginx:latest
```
use ```docker ps``` to list running containers
``` bash
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                               NAMES
86335dfeaa0b   nginx:latest   "/docker-entrypoint.…"   7 seconds ago   Up 6 seconds   0.0.0.0:80->80/tcp, :::80->80/tcp   web-ngnix
```

We can see that the container is running in daemon mode.
That the exposure of the ports is well done and that the name of the container is the one that we specified in parameter

``` bash
$ docker exec -it web-ngnix bash
```
The docker exec command runs a new command in a running container.

``` bash
$ root@nginx-container:/# 
```

We can now see that the name specified in ```--hostname``` is applied


## DOCKER VOLUMES 

#### The advantages of volumes : 
* Easy to persist data.
* Convenient for making backups
* Share data between multiple containers
* Multi-containers and permissions


#### Basic command for managed volumes :

* ```docker volume ls``` : list volumes 

* ```docker volume create <name>``` : creating a new volume

* ```docker volume rm <name>``` : delete a volume

* ```docker volume inspect <name>``` : inspection of a volume

#### The different types of volumes :
* Bind Mount : ```Bind mounts are dependent on the directory structure and OS of the host machine```
* Volumes Docker : ```volumes are completely managed by Docker```
* TMPFS : ```As opposed to volumes and bind mounts, a tmpfs mount is temporary, and only persisted in the host memory. When the container stops, the tmpfs mount is removed, and files written there won’t be persisted.```

## DOCKER RUN WITH VOLUMES

#### 1. Bind Mount  :

```sudo mkdir /data``` (creation of mount folder is necessary otherwise error will appear when using docker run)

```docker run -d --name TestBindMount --mount type=bind,source=/data/,target=/usr/share/nginx/html -p 80:80 nginx:latest```

```docker exec -ti TestBindMount bash```

#### 2. Volumes Docker :

```docker volume create mynginx``` (optional because if the volume is not created, docker will do it)

```docker run -d --name TestVolume --mount type=volume,src=mynginx,destination=/usr/share/nginx/html -p 81:80 nginx:latest```

```docker exec -ti TestVolume bash```

#### 3. Tmpfs:

```docker run -d --name TestTmpfs --mount type=tmpfs,destination=/usr/share/nginx/html -p 82:80 nginx:latest```

```docker exec -ti TestTmpfs bash```

#### To check data persistence you can delete all containers and recreate them !! (do not recreate the volumes)

``` bash
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS              PORTS                               NAMES
f0096643b045   nginx:latest   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:82->80/tcp, :::82->80/tcp   TestTmpfs
92260c1f5880   nginx:latest   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:81->80/tcp, :::81->80/tcp   TestVolume
dcad272f7531   nginx:latest   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp, :::80->80/tcp   TestBindMount
```

In each container modify/create the /usr/share/nginx/html/index.html, Remove containers and recreate.
Now check if the changes have been saved.
 
If you are running docker on your OS.
You can admire the changes from your websites.

* TestBindMount : http://localhost:80
* TestVolume : http://localhost:81
* TestTmpfs : http://localhost:82

## ENVIRONEMENT VARIABLE (ENV, ENVFILE...)

``` bash
$ docker run -tid --name testenv --env MYVAR="123" debian:latest
```
Add to the docker environment the variable MYVAR=123
``` bash
$ docker exec -ti testenv bash
```
Look in the container for the environment variables with the "env" command.
```
root@cb9e44034297:/# env
HOSTNAME=cb9e44034297
MYVAR=123
PWD=/
HOME=/root
TERM=xterm
SHLVL=1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
_=/usr/bin/env
```

This method works but is not secure for example for passwords.
To do this we will be able to add an env file ".ENV"

To do this, we will create a ".ENV" file in which we will put our environment variables. 
"```vim  .ENV```" 

```
MYPASSWORD="safepassword"
MYUSER="secretuser"
MYDB="BDD1"
```
```
$ docker run -tid --name testenv --env-file .ENV debian:latest
$ docker exec -ti testenv bash
```
Look in the container for the environment variables with the "env" command.


```
root@553c2ac8a657:/# env
HOSTNAME=553c2ac8a657
PWD=/
HOME=/root
MYPASSWORD="safepassword"
TERM=xterm
SHLVL=1
MYUSER="secretuser"
MYDB="BDD1"
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
_=/usr/bin/env
```

## DOCKER NETWORK

- Communication between containers or outside
- Different types : bridge, host, none, overlay
- Be careful, a container does not have a fixed IP address (stop / start)


#### Basic command for managed network :

* ```docker network ls``` : List networks

* ```docker network create <name>``` : Create a network

* ```docker network rm <name>``` : Remove one or more networks

* ```docker network inspect <name>``` : Display detailed information on one or more networks


#### IPs are not static

In general, IPs in a network are not static.

The addressing of the Ips depends on the starting order of the containers.

#### Exemple

Create bridge network with name, mynetwork :
``` bash
$ docker network create --driver=bridge mynetwork
```
Start two container connect to network "mynetwork"
``` bash
$ docker run -d --name c1 --network mynetwork nginx:latest
$ docker run -d --name c2 --network mynetwork nginx:latest
```
Container 1 will have as ip address : 172.26.0.2 
```
$ docker inspect c1 --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
172.26.0.2 
```
Container 2 will have as ip address : 172.26.0.3
```
$ docker inspect c2 --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
172.26.0.3
```
We will now reverse the boot order
```
sudo docker stop c1
sudo docker stop c2
### reverse containers start order ###
sudo docker start c2
sudo docker start c1
```
We can see that the ip addresses are no longer the same
```
docker inspect c1 --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
172.26.0.3
```

```
docker inspect c2 --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
172.26.0.2
```
### If the ips change, how do the containers communicate ?

The containers will have to communicate with their name which redirects to the ip.

```
sudo docker exec -ti c1 bash 
root@54bb6caca8fb:/# apt update && apt install iputils-ping -y
### ping install ###
root@54bb6caca8fb:/# ping c2
PING c2 (172.26.0.2) 56(84) bytes of data.
64 bytes from c2.mynetwork (172.26.0.2): icmp_seq=1 ttl=64 time=0.099 ms
64 bytes from c2.mynetwork (172.26.0.2): icmp_seq=2 ttl=64 time=0.204 ms
```

It will therefore be necessary to use the name of the containers,
in our different configurations, applications, programs to communicate.
Container names are used as domain names.

## DOCKERFILE

Dockerfile is a configuration file for the purpose of creating an image

#### Dockerfile benefit
* Restart an image creation at any time
* Better configuration visibility
* Dockerfile editing script
* Image creation, production or development


### Instructions Dockerfile

| □|   Instructions       |  Description |
| :-| :------------------- | :-------------|
| 1 | FROM                 | New build stage and sets the Base Image for subsequent instructions.|
| 2 | MAINTAINER           | author         |
| 3 | ARG                  | Defines a variable that users can pass when building the image             |
| 4 | ENV	               | Environment variable   |
| 4 | LABEL                | Adding metadata              |
| 5 | VOLUME               | Create a mount point              |
| 6 | RUN	               | Execute a command when creating the image            |
| 6 | COPY // ADD          | Add a file and directory in the image               |
| 6 | WORKDIR              | Allows you to change the current path             |
| 7 | EXPOSE               | Port listened by the container (metadata)        |
| 9 | CMD // ENTRYPOINT    | Execute a command when the container starts     |



## BUILD A IMAGE
#### We will now create a mariadb image

Here are the different files we need to build the image

```bash
$ tree
.
├── 50-server.cnf  # Mariadb configuration file
├── Dockerfile     # The dockerfile to build the image
└── script.sh      # Database configuration script
```


```Dockerfile```
``` .Dockerfile
# SPECIFIES DISTRIBUTION
FROM debian:buster

# UPDATE AND INSTALLATION
RUN apt-get update
RUN apt install -y mariadb-server 

# COPY THE CONF FOR THE BIND AND THE SQL SCRIPT FOR THE PRIVILEGE
COPY 50-server.cnf /etc/mysql/mariadb.conf.d/

# COPY THE SCRIPT IN THE IMAGES AND MODIFY THE EXECUTION RIGHTS OF IT
COPY script.sh /
RUN chmod +x /script.sh

ENTRYPOINT [ "/script.sh" ]
```
By default, the server does not accept external connections, or rather, it only accepts local connections (from the LoopBack address: localhost = 127.0.0.1).
We need change that !

```50-server.cnf```
``` .cnf
[server]

[mysqld]

user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
socket                  = /run/mysqld/mysqld.sock
port                    = 3306
basedir                 = /usr
datadir                 = /var/lib/mysql
tmpdir                  = /tmp
lc-messages-dir         = /usr/share/mysql
lc-messages             = en_US
skip-external-locking

# bind-address          = 127.0.0.1  # You need to change this line to allow external connections
bind-address            = 0.0.0.0    # Now it's better :-)

expire_logs_days        = 10
character-set-server  = utf8mb4
collation-server      = utf8mb4_general_ci

[embedded]

[mariadb]

[mariadb-10.5]
```


Script.sh will be executed at entrypoint at runtime.
this allow us to initialize the environment variables with an ```.env```file

```script.sh```

``` .sh
#!/bin/sh
service mysql start 

# CREATE USER #
echo "CREATE USER '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';" | mysql

# PRIVILGES FOR ROOT AND USER FOR ALL IP ADRESS #
echo "GRANT ALL PRIVILEGES ON *.* TO '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';" | mysql
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$BDD_ROOT_PASSWORD';" | mysql
echo "FLUSH PRIVILEGES;" | mysql

# CREAT WORDPRESS DATABASE #
echo "CREATE DATABASE $BDD_NAME;" | mysql

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld
```
## DOCKER BUILD : 
```
$ docker build -t my-mariadb .  
......
......
Successfully built 6ad0c955aa67
Successfully tagged my-mariadb:latest 👍
```

For this example, we'll change to ``\home`` and run `my-mariadb` image with an environment file.


``` bash 
$ cd /home
```

Create .env file in which `username`, `user`, `password`, `database name`, `root password`.

This information will be embedded in the container at runtime.
```
$ vim .env
BDD_USER=user
BDD_USER_PASSWORD=safepwd
BDD_NAME=wordpress
BDD_ROOT_PASSWORD=safepwdroot
```
To run the image you will need a specific env file and image name
```
$ docker run -tid --name testmariadb --env-file .env my-mariadb
```
The container is well executed, we can check with a `docker ps`
```
$ docker ps
CONTAINER ID   IMAGE        COMMAND        CREATED          STATUS          PORTS     NAMES
34e058b2f18f   my-mariadb   "/script.sh"   22 seconds ago   Up 22 seconds             testmariadb
```
Enter the container to check if our variables have integrated
```
$ docker exec -ti testmariadb bash                            
root@34e058b2f18f:/# 
```
Everything is good 🤩
```
root@34e058b2f18f:/# env
HOSTNAME=34e058b2f18f
PWD=/
BDD_NAME=wordpress
HOME=/root
BDD_USER_PASSWORD=safepwd
TERM=xterm
SHLVL=1
BDD_ROOT_PASSWORD=safepwdroot
BDD_USER=user
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
_=/usr/bin/env
```
Check if the conf file has been copied
``` .cnf
root@34e058b2f18f:/# cat /etc/mysql/mariadb.conf.d/50-server.cnf 

[server]

[mysqld]

user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
socket                  = /run/mysqld/mysqld.sock
port                    = 3306
basedir                 = /usr
datadir                 = /var/lib/mysql
tmpdir                  = /tmp
lc-messages-dir         = /usr/share/mysql
lc-messages             = en_US
skip-external-locking

bind-address            = 0.0.0.0

expire_logs_days        = 10
character-set-server  = utf8mb4
collation-server      = utf8mb4_general_ci

[embedded]

[mariadb]
```
Let's start mysql to check users and database
```
root@34e058b2f18f:/# mysql 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 10.3.38-MariaDB-0+deb10u1 Debian 10

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```
Check if our user and root is enabled for any host
``` sql
MariaDB [(none)]> SELECT user,host,password FROM mysql.user;
+------+-----------+-------------------------------------------+
| user | host      | password                                  |
+------+-----------+-------------------------------------------+
| root | localhost |                                           |
| user | %         | *1C848575FF465642717BE88F2015E168769A62F3 |
| root | %         | *FDB22E6F75BD75009DEE947AFD0BD73CB7EB88DA |
+------+-----------+-------------------------------------------+
3 rows in set (0.005 sec)
```
Check if the "wordpress" database has been created
``` sql
MariaDB [(none)]> SHOW databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| wordpress          |
+--------------------+
4 rows in set (0.005 sec)
```




# Starter Pack [ MariaDB - Adminer ]

<img src="./.img_readme/adminer_sql.png">

In the previous part we saw how to write a dockerfile and build the image using `docker build`

In this part we will see how to use `docker compose` and write a `docker-compose.yml`

But first, we will see the configuration and the creation of the dockerfile for Adminer.

Adminer is a tool for managing content in databases. It natively supports MySQL, MariaDB, PostgreSQL, SQLite,

Once installed, we will be able to connect to our database from the Web Adminer interface 😎

```Dockerfile``` (Adminer)

``` .Dockerfile
# SPECIFIES DISTRIBUTION
FROM debian:buster

# UPDATE AND INSTALLATION
RUN apt-get update 
RUN apt install -y adminer 

# COPY THE CONF FILE 
COPY 000-default.conf /etc/apache2/sites-available/
RUN echo 'ServerName adminer' >> /etc/apache2/apache2.conf

# START AND CONF 
RUN service apache2 start && a2enconf adminer.conf 

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

```000-default.conf``` (Adminer)
``` .conf
<VirtualHost *:80>
        DocumentRoot /etc/adminer
        Alias /adminer /etc/adminer
        
        <Directory /etc/adminer>
                Require all granted
                DirectoryIndex conf.php
        </Directory> 

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

## DOCKER-COMPOSE

#### What is Docker Compose?
Docker Compose is a tool that was developed to help define and share multi-container applications. 

With Compose, we can create a YAML file to define the services and with a single command, can spin everything up or tear it all down.
### BASIC DOCKER COMMANDS

* ```docker-compose build``` : To build the images
* ```docker-compose up -d``` : To run containers in daemon mode
* ```docker-compose up --build -d``` : To build images and run containers in daemon mode {my favorite :-)}
* ```docker-compose start/stop``` : To start and stop services
* ```docker-compose down``` : To stop and delete containers


It is important that the project structure is consistent with the dockerfiles and docker-compose.yml

``` bash
$ tree 
.
├── adminer_directory
│   ├── 000-default.conf 
│   └── Dockerfile
├── docker-compose.yml
├── .env               # same .env as before 
├── mariadb_directory
│   ├── 50-server.cnf  # Same file seen above
│   ├── Dockerfile     # Same file seen above
│   └── script.sh      # Same file seen above
└── my_volume.         # Persistent volume
```

```docker-compose.yml```

``` .yml
version: '3.5'
services:
  adminer:
    container_name: Adminer     # Name redirect to IP -> 172.X.X.Z
    build: adminer_directory/.  # Build the dockerfile in ./adminer_directory/Dockerfile 
    restart: always             # Restart the container if it has stopped
    ports:
      - "80:80"                 # Redirect port 80 of Adminer on the host
    networks:
      - mynetwork               # Use mynetwork for communicate with mariadb
  
  mariadb:
    container_name: Mariadb
    build: mariadb_directory/.
    restart: always
    networks:
      - mynetwork
    volumes:
      - db:/var/lib/mysql
    env_file: .env

# NETWORK
networks:
  mynetwork:
    name : mynetwork
    driver : bridge         # Remember the different types of Networks, I showed you before ???

# VOLUME
volumes:
  db:
    driver: local
    driver_opts:            # Options specific to the driver
      type: 'none'
      o: 'bind'
      device: ./my_volume   # Persistent volume
```
The docker-compose.yml is edited.

The various essential elements of the infrastructure being positioned in the right place.

We will be able to launch our infrastructure using the command : `docker-compose up --build -d` .

This will build and then launch the images.
``` .sh
$ docker-compose up --build -d
....
....
Creating Mariadb ... done
Creating Adminer ... done
```

``` .sh
$ docker ps 
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS         PORTS                               NAMES
5b1e14853a6e   mdb-adm_adminer   "/usr/sbin/apache2ct…"   1 minutes ago   Up 1 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp   Adminer
4cb7c3cb88f8   mdb-adm_mariadb   "/script.sh"             1 minutes ago   Up 1 minutes                                       Mariadb
```

The launch of our containers went well.

We will be able to connect to our database through the Adminer web interface using the host address.

For my part, the address of my host is `192.168.64.13`, because i work remotely on a vm.

Most likely your host address is `localhost` or `127.0.0.1`.

Adminer will ask us for the connection information.

This information corresponds to the information present in the ".env" file

The server address to enter is `Mariadb`

```
USERNAME = user
PASSWORD = safepwd
DATABASE = wordpress
``` 

<img src="./.img_readme/login_Adminer1.png">

Great the connection works 👍🏼

<img src="./.img_readme/login_Adminer2.png">

You can also log in as root. You just have to put in "root" in user and the password present in the env file.


# PHP-FPM & NGNIX 

<img src="./.img_readme/nginx_php_fpm.png">


In this part we will create a simple infrastructure allowing to separate nginx and php.

We will then use this same infrastructure to implement the SSL certificate and communicate only on port 443 to connect to our web server.

``` bash 
$ tree
.
├── docker-compose.yml
├── nginx
│   ├── conf
│   │   └── default
│   └── Dockerfile
└── wordpress
    ├── conf
    │   ├── index.php
    │   └── www.conf
    └── Dockerfile
```


To work, nginx and php need to have access to the same file.

This is why our "wordress" volume is common to both containers.

Both will share the folder ```/var/www/html```

``` docker-compose.yml```

``` .yml
version: '3.5'
services:
  ngnix:
    container_name: ngnix
    build: ./nginx/
    restart: always
    volumes:
     - WordPress:/var/www/html
    depends_on:
      - wordpress
    ports:
      - "80:80"
    networks:
      - mynetwork

  wordpress:
    container_name: wordpress
    build: ./wordpress/
    restart: always
    volumes:
     - WordPress:/var/www/html
    networks:
     - mynetwork
  
# NETWORK
networks:
  mynetwork:
    name : mynetwork
    driver : bridge

# VOLUME
volumes:
  WordPress:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: /home/tliot/data/website
```

## Installing NGINX

```Dockerfile```

``` .Dockerfile
# SPECIFIE LA DISTRIBUTION
FROM debian:buster
RUN apt-get update

# NGINX INSTALLATION
RUN apt-get install -y nginx

# Copy of default web page configuration
COPY ./conf/default    /etc/nginx/sites-available/default

ENTRYPOINT ["nginx", "-g", "daemon off;"]
```

```default```

```
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        server_name _;

        root /var/www/html/wordpress;
        index index.php ;
        
        # logging
        access_log /var/log/nginx/wordpress.access.log;
        error_log /var/log/nginx/wordpress.error.log;
        
        location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                try_files $uri = 404;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass wordpress:9000; # <------------ Redirect to wordpress container
                fastcgi_index index.php;
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param PATH_INFO $fastcgi_path_info;
        }
}
```

## Installing PHP-FPM


```dockerfile```

``` .Dockerfile
# SPECIFIE LA DISTRIBUTION
FROM debian:buster
RUN apt-get update

# UDPATE & INSTALLATION
RUN apt install php-fpm  -y

# To create the PID file (/run/php/php7.3-fpm.pid)
RUN mkdir /run/php

# To allow external connections
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

# To create index.php  
COPY ./conf/index.php    /var/www/html/wordpress/index.php

# Is optional, just a metadata
EXPOSE 9000 

ENTRYPOINT ["/usr/sbin/php-fpm7.3","-F" ]
```

```index.php```
```
<? php echo phpinfo(); ?>
```

``` www.conf ```

``` .conf
[www]
user = www-data
group = www-data
# listen = 127.0.0.1:9000 # Change this line
listen = 9000             # Now it's better
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
```

## Connecting NGINX

<img src="./.img_readme/web-nginx-php.png">

# Local Domains in Linux

#### Configure DNS Locally Using /etc/hosts File in Linux


Now open the /etc/hosts file using your editor of choice as follows

```sudo vi /etc/hosts```

Then add the lines below to the end of the file as shown in the screen shot below.

```
127.0.0.1	    localhost
255.255.255.255	broadcasthost
::1             localhost

192.168.64.13	tliot.42.fr          # <--- Principal Domains
192.168.64.13	adminer.tliot.42.fr  # <--- adminer subdomain (optional)
192.168.64.13	*.tliot.42.fr        # <--- all subdomain (optional)

```

Next, test if everything is working well as expected, using the ping command. 

```
$ ping tliot.42.fr
PING tliot.42.fr (192.168.64.13): 56 data bytes
64 bytes from 192.168.64.13: icmp_seq=0 ttl=64 time=1.919 ms
64 bytes from 192.168.64.13: icmp_seq=1 ttl=64 time=2.046 ms
64 bytes from 192.168.64.13: icmp_seq=2 ttl=64 time=2.391 ms
64 bytes from 192.168.64.13: icmp_seq=3 ttl=64 time=2.017 ms
64 bytes from 192.168.64.13: icmp_seq=4 ttl=64 time=2.481 ms
^C
--- tliot.42.fr ping statistics ---
5 packets transmitted, 5 packets received, 0.0% packet loss
```

# Setup a self-signed SSL certificate

#### Create the self-signed SSL certificate:

```
RUN openssl req \
            -x509 \
            -nodes \
            -days 365 \
            -newkey rsa:2048 \
            -keyout /etc/ssl/private/nginx-selfsigned.key \
            -out /etc/ssl/certs/nginx-selfsigned.crt \
            -subj '/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=42Paris/CN=TLIOT/UID=TTT'
```

#### Create a new configuration snippet file for Nginx:

```
RUN echo "ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;\nssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;" > /etc/nginx/snippets/self-signed.conf
```

#### Create a strong Diffie-Hellman group:

```
RUN openssl dhparam -out /etc/nginx/dhparam.pem 2048
```
#### Create a configuration snippet with strong encryption settings:
```
COPY ./conf/ssl-params.conf /etc/nginx/snippets/
```

```ssl-params.conf```

```
ssl_prefer_server_ciphers on;
ssl_dhparam /etc/nginx/dhparam.pem; 
ssl_ciphers EECDH+AESGCM:EDH+AESGCM;
ssl_ecdh_curve secp384r1;
ssl_session_timeout  10m;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
```


#### Configure Nginx site to use certificate:

```
server {
        listen 443 ssl default_server;      <--- 80 to 443
        listen [::]:443 ssl default_server; <--- 80 to 443

        server_name tliot.42.fr;            <--- _ to tliot.42.fr

        # ssl 
        include snippets/self-signed.conf;  <--- self-signed SSL
        include snippets/ssl-params.conf;   <--- strong encryption

        root /var/www/html/wordpress;
        index index.php ;
        
        # logging
        access_log /var/log/nginx/wordpress.access.log;
        error_log /var/log/nginx/wordpress.error.log;
        
        location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                try_files $uri = 404;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass wordpress:9000;
                fastcgi_index index.php;
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param PATH_INFO $fastcgi_path_info;
        }
}
```


#### Configure docker-compose.yml site to use 443:

```docker-compose.yml```

```
  ngnix:
    container_name: ngnix
    build: ./nginx/
    restart: always
    volumes:
     - WordPress:/var/www/html
    depends_on:
      - wordpress
    ports:
      - "443:443"   <--- 80:80 to 443:443
    networks:
      - mynetwork
```



### Testing the SSL Server

Next, test whether the SSL encryption is working.

On your browser, type the prefix ```http://``` then your domain name:

```https://server_domain```

Since the certificate is not already signed by a trusted certificate authority, you will most likely get a warning like the one below:

You will see a warning that may pop-up because the SSL certificate created earlier isn’t signed by a trusted certificate authority:

<img src="./.img_readme/ssl1.png">

It's goood 👍🏼

<img src="./.img_readme/ssl2.png">