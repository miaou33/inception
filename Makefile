DATA_DIR = /home/nfauconn/data
DOCKER_COMPOSE_YML = srcs/docker-compose.yml

NGINX = /var/lib/docker/nginx
MARIADB = /var/lib/docker/mariadb
WORDPRESS = /var/lib/docker/wordpress

SRC_NGINX = srcs/nginx/Dockerfile
SRC_MARIADB = srcs/mariadb/Dockerfile
SRC_WORDPRESS = srcs/wordpress/Dockerfile

all:	up

up:	build
	sudo docker --log-level WARNING compose -f ${DOCKER_COMPOSE_YML} up

down:	
	sudo docker compose -f ${DOCKER_COMPOSE_YML} down

build:
	sudo mkdir -p ${DATA_DIR}/mariadb_data
	sudo mkdir -p ${DATA_DIR}/wordpress_data
	sudo docker --log-level WARNING compose -f ${DOCKER_COMPOSE_YML} build
	

run:	build
	sudo docker-compose run

clean: down
	sudo docker system prune -af
	-$(sudo docker volume rm -f $(sudo docker volume ls -q) 2>/dev/null)
	sudo rm -rf ${DATA_DIR}

re:	clean
	make all

.PHONY: all build up down run nginx mariadb wordpress clean re 
