FROM debian:buster

RUN apt update && apt upgrade
RUN apt install -y curl vim
RUN apt install -y nginx openssl

# Copie des fichiers de configuration
COPY conf/default /etc/nginx/sites-available/nginx.conf

# Exposition du port 80
EXPOSE 80

# Commande par défaut lors du lancement du conteneur
#CMD ["nginx", "-g", "daemon off;"]
