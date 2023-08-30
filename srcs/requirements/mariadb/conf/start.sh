#!/bin/sh
#
## Create a directory to hold the MariaDB server process's PID file
#mkdir /var/run/mysqld
## Change the ownership of the /var/run/mysqld directory to the mysql user
#chown -R mysql:mysql /var/run/mysqld
#
## Initialize the MariaDB data directory and create the system tables
#mysql_install_db --user=mysql --datadir=/var/lib/mysql
#
#mysql << EOF
#CREATE DATABASE ${DB_NAME};
#CREATE USER '${DB_USR}'@'%' IDENTIFIED BY '${DB_USR_PWD}';
#GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USR}'@'%';
#ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';
#EOF
#
#exec mysqld --user=mysql

# On crée un répertoire pour le socket MariaDB.
# On rend l'utilisateur qui exécute mariaDB propriétaire de ce dernier.
mkdir /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

# On vérifie que la base de données n'existe pas déjà.
if [ ! -d var/lib/mysql/${DB_NAME} ]; then
	# On initialise MariaDB.
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	# On lance le serveur MariaDB en arrière-plan.
	mysqld --user=mysql &

	# On s'assure que le serveur MariaDB est bien lancé.
	while ! mysqladmin ping -h localhost --silent; do
    	sleep 1
	done

	# On supprime les utilisateurs sans nom de notre serveur.
	# On supprime la DB 'test'.
	# On crée la base de données si elle n'existe pas déjà.
	# On crée un nouvel utilisateur.
	# On lui attribut tous les droits sur la base de données précédemment crée.
	# On modifie le mot de passe de l'utilisateur 'root'.
	mysql <<EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USR}'@'%' IDENTIFIED BY '${DB_USR_PWD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USR}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';
EOF

	# On stop le serveur MariaDB.
	mysqladmin -p${DB_ROOT_PWD} shutdown
fi

exec "$@"
