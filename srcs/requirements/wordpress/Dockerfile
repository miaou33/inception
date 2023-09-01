# Use Alpine 3.17 image
FROM alpine:3.17

# Install packages and WordPress
RUN apk update \
    && apk add php81 php81-fpm php81-json php81-common php81-mysqli wget \
    && wget https://wordpress.org/latest.tar.gz \
	&& tar -xzf latest.tar.gz \
	&& mkdir -p /var/www/ \
    && mv wordpress /var/www/wordpress \
    && rm latest.tar.gz

# Copy your WordPress config if you have one
# COPY wp-config.php /var/www/wordpress/

# PHP-FPM config
#COPY php-fpm.conf /etc/php81/php-fpm.d/www.conf

# Expose port
#EXPOSE 9000

# Start PHP-FPM
#CMD ["php-fpm81", "-F"]

