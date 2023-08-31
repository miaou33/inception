FROM alpine:3.17

# Install Nginx
RUN apk update && apk add mysql mysql-client

# Copy configuration file and startup script
COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY conf/start.sh /start.sh

# Expose MySQL port
EXPOSE 3306

# Set the startup script as the entry point
ENTRYPOINT [ "/start.sh" ]

CMD ["mysqld", "--user=mysql"]
