#!/bin/sh

mkdir -p /var/run/mysqld # Create the directory for MySQL's socket file
chown -R mysql:mysql /var/run/mysqld # Give MySQL user permission to write to the socket file directory
mkdir -p /var/log/mysql # Create the directory for MySQL's log files
chown -R mysql:mysql /var/log/mysql # Give MySQL user permission to write to the log file directory


# Check if MySQL data exists and if not, creates it
if [ ! -d /var/lib/mysql/mysql ]; then

	mysql_install_db --user=mysql --datadir=/var/lib/mysql # Install MySQL data files and create database directory structure

	mysqld --user=mysql & # Start MySQL in the background to create the root user and the WordPress database

	# Wait until the MySQL server is available.
	while ! mysqladmin ping -h localhost --silent; do 
    	sleep 1
	done

	# Create the WordPress database and configure the WordPress user
	mysql <<EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USR}'@'%' IDENTIFIED BY '${DB_USR_PWD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USR}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';
EOF

	mysqladmin -p${DB_ROOT_PWD} shutdown  # Stop MySQL
fi

exec "$@"
