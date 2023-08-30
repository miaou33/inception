#!/bin/sh

# Create a directory to hold the MariaDB server process's PID file
mkdir /var/run/mysqld
# Change the ownership of the /var/run/mysqld directory to the mysql user
chown -R mysql:mysql /var/run/mysqld

# Initialize the MariaDB data directory and create the system tables
mysql_install_db --user=mysql --datadir=/var/lib/mysql

for i in {30..0}; do
    if echo 'SELECT 1' | mysql &> /dev/null; then
        break
    fi
    echo 'MariaDB initialization in progress...'
    sleep 1
done

if [ "$i" = 0 ]; then
    echo >&2 'MariaDB initialization failed.'
    exit 1
fi

# Copy the database initialization script into the container's /docker-entrypoint-initdb.d directory that will be run when the container is started
#cp ./init.sql /docker-entrypoint-initdb.d/

exec mysqld --user=mysql
