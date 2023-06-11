FROM debian:buster

RUN apt update && apt upgrade
RUN apt install -y curl vim
RUN apt install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl && mkdir -p /etc/nginx/ssl/private && mkdir -p /etc/nginx/ssl/certs

RUN openssl req \
            -x509 \
            -nodes \
            -days 365 \
            -out /etc/nginx/ssl/certs/nginx-selfsigned.crt \
            -keyout /etc/nginx/ssl/private/nginx-selfsigned.key \
            -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=nfauconn.42.fr/UID=nfauconn" 

RUN mkdir -p /var/run/nginx

COPY conf/default /etc/nginx/sites-available/default

# Exposer le port 80 pour les requêtes HTTP et le port 443 pour les requêtes HTTPS
EXPOSE 80 443

# Définir la commande par défaut pour exécuter NGINX en mode daemon
CMD ["nginx", "-g", "daemon off;"]

