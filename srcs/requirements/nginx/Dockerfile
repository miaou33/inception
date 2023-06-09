# Utilise l'image de base Debian Buster
FROM debian:buster

# Met à jour le système et installe Nginx
RUN apt update \
    && apt install -y  vim \
                    curl \
                    nginx \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl \
	&& openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=nfauconn.42.fr/UID=nfauconn"

# Copie la configuration personnalisée de Nginx dans le conteneur
#COPY nginx.conf /etc/nginx/nginx.conf

# Expose le port 80 pour le trafic HTTP
#EXPOSE 80

# Lance le service Nginx lors du démarrage du conteneur
#CMD ["nginx", "-g", "daemon off;"]

