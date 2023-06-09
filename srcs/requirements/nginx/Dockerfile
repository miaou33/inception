# Utiliser l'image Alpine v3.17 comme base
FROM alpine:3.17

# Mettre à jour les packages et installer NGINX
RUN apk update && apk upgrade && apk add --no-cache nginx curl vim openssl

RUN nginx
RUN openssl req -x509 -nodes -days 365 -subj "/C=FR/ST=Ile-de-France/O=42, Inc./CN=nfauconn.42.fr" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt;
RUN echo "<h1>Hello world!</h1>" > /var/www/localhost/htdocs/index.html;

# Copier le fichier de configuration NGINX
COPY $PWD/conf/http.d/default.conf /etc/nginx/http.d/default.conf

# Exposer le port 80 pour les requêtes HTTP et le port 443 pour les requêtes HTTPS
EXPOSE 80 443

# Définir la commande par défaut pour exécuter NGINX en mode daemon
#CMD ["nginx", "-g", "daemon off;"]

