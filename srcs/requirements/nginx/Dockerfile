FROM alpine:3.17

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache nginx \
	                      openssl

RUN mkdir -p /run/nginx \
	&& mkdir -p /var/www/wordpress \
    && mkdir -p /etc/nginx/ssl \
    && chown -R nginx:nginx /var/log/nginx

RUN openssl req -x509 \ 
				-nodes \ 
				-days 365 \ 
				-newkey rsa:2048 \ 
				-subj '/CN=nfauconn' \ 
				-keyout /etc/nginx/ssl/nginx.key \ 
				-out /etc/nginx/ssl/nginx.crt

RUN mkdir -p /run/nginx

COPY conf/default.conf /etc/nginx/http.d/default.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
