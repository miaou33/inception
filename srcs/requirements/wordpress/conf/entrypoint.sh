#!/bin/sh

# Make sure that MariaDB is up and running before starting WordPress
while ! mysql -h mariadb -u$DB_USR -p$DB_USR_PWD --silent > /dev/null 2>&1; do
    sleep 1
done

# Verify if WordPress is already installed.
if [ ! -f /var/www/wordpress/wp-config.php ]; then

    curl -O https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz
    tar xf wordpress-6.0-fr_FR.tar.gz
    mv wordpress/* /var/www/wordpress/
    rm wordpress-6.0-fr_FR.tar.gz
    rm -r wordpress/

    cd /var/www/wordpress

    # Creation of wp-config.php
    wp config create                        \
    --dbname=$DB_NAME                       \
    --dbuser=$DB_USR                       \
    --dbpass=$DB_USR_PWD                \
    --dbhost=mariadb
            
    # Installation of WordPress
    wp core install                         \
    --url=https://nfauconn.42.fr            \
    --title="[ WordPress by nfauconn ]"      \
    --admin_user=$WP_ROOT_USR              \
    --admin_password=$WP_ROOT_PWD       \
    --admin_email=$WP_ROOT_MAIL            \
    --skip-email

    # Creation of a new user
    wp user create                          \
    $WP_USR_NAME                           \
    $WP_USR_MAIL                            \
    --user_pass=$WP_USR_PWD
fi

# Start PHP and Nginx
exec "$@"
#exec "php-fpm81 --nodaemonize --fpm-config /etc/php81/php-fpm.d/www.conf -y /etc/php81/php-fpm.conf --force-stderr"
#exec "php-fpm81 -F -R >> /var/log/php81/fpm-start.log 2>&1"

