# Utilise l'image de base Debian Buster
FROM debian:buster

# Met à jour le système et installe Nginx
RUN apt update && \
    apt install -y  vim \
					curl \
					nginx && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Copie la configuration personnalisée de Nginx dans le conteneur
#COPY nginx.conf /etc/nginx/nginx.conf

# Expose le port 80 pour le trafic HTTP
#EXPOSE 80

# Lance le service Nginx lors du démarrage du conteneur
#CMD ["nginx", "-g", "daemon off;"]

