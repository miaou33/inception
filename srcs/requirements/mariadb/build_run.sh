docker build -t my-mariadb .
docker run -d --env-file ../../.env -p 3306:3306 my-mariadb
#docker run -it my-mariadb --env-file ../../.env
echo "docker exec -it [CONTAINER_ID] /bin/sh"
