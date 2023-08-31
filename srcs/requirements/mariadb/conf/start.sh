#!/bin/sh

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then

	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	mysqld --user=mysql &

	while ! mysqladmin ping -h localhost --silent; do
    	sleep 1
	done

	mysql <<EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USR}'@'%' IDENTIFIED BY '${DB_USR_PWD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USR}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';
EOF

	mysqladmin -p${DB_ROOT_PWD} shutdown
fi

exec "$@"
