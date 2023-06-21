#!/bin/sh
service mysql start 

# CREATE USER #
mysql -e "CREATE USER '$MDB_USR'@'%' IDENTIFIED BY '$MDB_USR_PWD';"

# PRIVILGES FOR ROOT AND USR FOR ALL IP ADRESS #
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$MDB_USR'@'%' IDENTIFIED BY '$MDB_USR_PWD';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MDB_ROOT_PWD';"
mysql -e "FLUSH PRIVILEGES;"

# CREAT WORDPRESS DATABASE #
mysql -e "CREATE DATABASE $MDB_NAME;"

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld
##!/bin/sh
#service mysql start 
#
## CREAT WORDPRESS DATABASE #
#mysql -e "CREATE DATABASE IF NOT EXISTS $MDB_DB"
#
## CREATE USR #
#mysql -e "CREATE USER IF NOT EXISTS '$MDB_USR'@'%' IDENTIFIED BY '$MDB_USR_PWD';"
#
## PRIVILGES FOR ROOT AND USR FOR ALL IP ADRESS #
#mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$MDB_USR'@'%' IDENTIFIED BY '$MDB_USR_PWD';"
##mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MDB_ROOT_PWD';"
#mysql -e "ALTER USR 'root'@'localhost' IDENTIFIED BY '${MDB_ROOT_PWD}';"
#mysql -e "FLUSH PRIVILEGES;"
#
#
##mysqladmin -u root -p$MDB_ROOT_PWD shutdown
#kill $(cat /var/run/mysqld/mysqld.pid)
#
#mysqld
