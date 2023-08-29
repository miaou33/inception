#!/bin/sh

# Create a directory to hold the MariaDB server process's PID file
mkdir /var/run/mysqld
# Change the ownership of the /var/run/mysqld directory to the mysql user
chown -R mysql:mysql /var/run/mysqld

# Initialize the MariaDB data directory and create the system tables
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Copy the database initialization script into the container's /docker-entrypoint-initdb.d directory that will be run when the container is started
#cp ./init.sql /docker-entrypoint-initdb.d/

exec mysqld --user=mysql
