FROM debian:buster

RUN apt update && apt upgrade
RUN apt install -y curl vim
RUN apt install -y nginx openssl

RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/ssl-selfsigned.crt \
       -keyout /etc/nginx/ssl/ssl-selfsigned.key \
       -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=nfauconn/CN=nfauconn"

COPY conf/default /etc/nginx/sites-available/default

RUN mkdir -p /run/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
