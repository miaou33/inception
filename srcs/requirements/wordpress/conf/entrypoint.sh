#!/bin/sh

while ! mysql -h mariadb -u$DB_USR -p$DB_USR_PWD --silent > /dev/null 2>&1; do
    sleep 1
done

if [ ! -f /var/www/wordpress/wp-config.php ]; then

    curl -O https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz
    tar xf wordpress-6.0-fr_FR.tar.gz
    mv wordpress/* /var/www/wordpress/
    rm wordpress-6.0-fr_FR.tar.gz
    rm -r wordpress/

    cd /var/www/wordpress

    # create the wp-config.php
    wp config create                        \
    --dbname=$DB_NAME                       \
    --dbuser=$DB_USR						\
    --dbpass=$DB_USR_PWD					\
    --dbhost=mariadb
            
    wp core install                         \
    --url=$DOMAIN_NAME						\
    --title="Inception"						\
    --admin_user=$WP_ROOT_USR               \
    --admin_password=$WP_ROOT_PWD			\
    --admin_email=$WP_ROOT_MAIL				\
    --skip-email

    wp user create                          \
    $WP_USR_NAME							\
    $WP_USR_MAIL                            \
    --user_pass=$WP_USR_PWD
fi

exec "$@"

