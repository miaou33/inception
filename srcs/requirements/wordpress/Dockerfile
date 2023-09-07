FROM alpine:3.17

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache php81 \
						  php81-common \
						  php81-ctype \
						  php81-curl \
						  php81-dev \
						  php81-dom \
	                      php81-fpm \
						  php81-gd \
						  php81-intl \
						  php81-json \
						  php81-mbstring \
						  php81-mysqli \
						  php81-opcache \
						  php81-openssl \
						  php81-pdo \
						  php81-pdo_mysql \
						  php81-pear \
						  php81-phar \
						  php81-session \
						  php81-tokenizer \
						  php81-xml \
						  php81-xmlreader \
						  php81-zlib \
						  mariadb-client \
						  wget \
    && wget https://wordpress.org/latest.tar.gz \
	&& tar -xzf latest.tar.gz \
    && rm latest.tar.gz

RUN mkdir -p /var/www/wordpress

RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && adduser -D php                  \
    && chmod +x wp-cli.phar         \
    && mv wp-cli.phar /usr/local/bin/wp 

RUN chown -R php:php /var/log/php81

COPY conf/www.conf /etc/php81/php-fpm.d/www.conf
COPY conf/entrypoint.sh /entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm81", "-F"]
