# Use Alpine Linux's penultimate version as the base image.
FROM alpine:3.17

# Install Nginx
RUN apk update && \
    apk add nginx openssl

# Create necessary folders and give permissions
RUN mkdir -p /run/nginx && \
    mkdir -p /etc/nginx/ssl

# Generate a self-signed SSL certificate (For testing purposes only)
# -x509 tells OpenSSL to create a self-signed certificate
# -nodes tells OpenSSL to skip the option to secure our certificate with a passphrase
# -days 365 sets the length of time our certificate will be considered valid
# rsa:2048 sets the size of the RSA key to create
# -subj allows us to specify the fields of our certificate's Subject property
# -keyout saves the private key file generated
# -out saves the certificate file generated

RUN openssl req -x509 \ 
				-nodes \ 
				-days 365 \ 
				-newkey rsa:2048 \ 
				-subj '/CN=nfauconn' \ 
				-keyout /etc/nginx/ssl/nginx.key \ 
				-out /etc/nginx/ssl/nginx.crt

# Create necessary folders and give permissions
RUN mkdir -p /run/nginx

# Copy over configuration files if needed
COPY conf/default.conf /etc/nginx/http.d/default.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose the port Nginx will run on
EXPOSE 443

# Start Nginx when the container starts
# daemon off: ensure that NGINX runs as the container's main process
CMD ["nginx", "-g", "daemon off;"]
