# Use Alpine 3.17 image
FROM alpine:3.17

# Set the working directory (creates it if it doesn't exist)
WORKDIR /var/www

# Install packages and WordPress
RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache php81 \
	                      php81-fpm \
						  php81-json \
						  php81-common \
						  php81-mysqli \
						  wget \
    && wget https://wordpress.org/latest.tar.gz \
	&& tar -xzf latest.tar.gz \
    && rm latest.tar.gz

# Download of the CLI (Command Line Interface) of WordPress that allows to manage the installation without using the web interface
# Creation of the user that will run the php-fpm process
# CLI is made executable and moved to the bin folder
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && adduser -D php                  \
    && chmod +x wp-cli.phar         \
    && mv wp-cli.phar /usr/local/bin/wp

# Reconfiguration of the php-fpm process
COPY conf/www.conf /etc/php8/php-fpm.d/www.conf
COPY conf/entrypoint.sh /entrypoint.sh

# Exposition of the port 9000 for the php-fpm process
EXPOSE 9000

# The container will start with the entrypoint.sh script that configures it and then execute the php-fpm8 process
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm8", "-F"]
