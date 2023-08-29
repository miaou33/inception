# Use Alpine Linux's penultimate version as the base image.
FROM alpine:3.17

# Install Nginx
RUN apk update && \
	apk add mysql mysql-client

# Copy configuration file and startup script
#COPY my.cnf /etc/mysql/my.cnf
COPY conf/start.sh /start.sh

# Expose MySQL port
EXPOSE 3306

# Set the startup script as the entry point
ENTRYPOINT [ "/start.sh" ]
