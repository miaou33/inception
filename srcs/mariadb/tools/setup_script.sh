#!/bin/sh
service mysql start 

# CREATE USER #
echo "CREATE USER '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';" | mysql

# PRIVILGES FOR ROOT AND USER FOR ALL IP ADRESS #
echo "GRANT ALL PRIVILEGES ON *.* TO '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';" | mysql
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$BDD_ROOT_PASSWORD';" | mysql
echo "FLUSH PRIVILEGES;" | mysql

# CREAT WORDPRESS DATABASE #
echo "CREATE DATABASE $BDD_NAME;" | mysql

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld
##!/bin/sh
#service mysql start 
#
## CREAT WORDPRESS DATABASE #
#mysql -e "CREATE DATABASE IF NOT EXISTS $MDB_DB"
#
## CREATE USER #
#mysql -e "CREATE USER IF NOT EXISTS '$MDB_USR'@'%' IDENTIFIED BY '$MDB_USR_PWD';"
#
## PRIVILGES FOR ROOT AND USER FOR ALL IP ADRESS #
#mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$MDB_USR'@'%' IDENTIFIED BY '$MDB_USR_PWD';"
##mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MDB_ROOT_PWD';"
#mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MDB_ROOT_PWD}';"
#mysql -e "FLUSH PRIVILEGES;"
#
#
##mysqladmin -u root -p$MDB_ROOT_PWD shutdown
#kill $(cat /var/run/mysqld/mysqld.pid)
#
#mysqld
