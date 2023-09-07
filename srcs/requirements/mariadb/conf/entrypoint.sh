#!/bin/sh

mkdir -p /var/run/mysqld # MySQL's socket file
chown -R mysql:mysql /var/run/mysqld
mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

if [ ! -d /var/lib/mysql/mysql ]; then

	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	mysqld --user=mysql &

	while ! mysqladmin ping -h localhost --silent; do 
    	sleep 1
	done

	mysql <<EOF
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USR}'@'%' IDENTIFIED BY '${DB_USR_PWD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USR}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';
EOF

	mysqladmin -p${DB_ROOT_PWD} shutdown
fi

exec "$@"
