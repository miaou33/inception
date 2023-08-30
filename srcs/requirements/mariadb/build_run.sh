source ../tools/asci_color.sh

echo -e "\n${boldlightgreen}EXEC: docker build -t my-mariadb .${reset}"
docker build -t my-mariadb .
echo -e "\n${boldlightgreen}EXEC: docker run -d --env-file ../../.env -p 3306:3306 my-mariadb${reset}"
docker run -d --env-file ../../.env -p 3306:3306 my-mariadb
#docker run -it my-mariadb --env-file ../../.env
echo -e "\n${boldlightgreen}TODO: docker exec -it [CONTAINER_ID] /bin/sh${reset}"
