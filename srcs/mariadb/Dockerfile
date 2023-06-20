FROM debian:buster

RUN apt update && apt upgrade

RUN apt install -y mariadb-server 

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY tools/setup_script.sh /

ENTRYPOINT [ "./setup_script.sh" ]

