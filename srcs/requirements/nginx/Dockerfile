# Use Alpine Linux's penultimate version as the base image.
FROM alpine:3.13

# Install Nginx
RUN apk update && \
    apk add nginx openssl

# Create necessary folders and give permissions
RUN mkdir -p /run/nginx && \
    mkdir -p /etc/nginx/ssl

# Generate a self-signed SSL certificate (For testing purposes only)
RUN openssl req -x509 \ # -x509 tells OpenSSL to create a self-signed certificate
				-nodes \ # -nodes tells OpenSSL to skip the option to secure our certificate with a passphrase
				-days 365 \ # -days 365 sets the length of time our certificate will be considered valid
				-newkey rsa:2048 \ # rsa:2048 sets the size of the RSA key to create
				-subj '/CN=nfauconn' \ # -subj allows us to specify the fields of our certificate's Subject property
				-keyout /etc/nginx/ssl/nginx.key \ # -keyout saves the private key file generated
				-out /etc/nginx/ssl/nginx.crt # -out saves the certificate file generated

# Create necessary folders and give permissions
RUN mkdir -p /run/nginx

# Copy over configuration files if needed
COPY conf/default.conf /etc/nginx/http.d/default.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose the port Nginx will run on
EXPOSE 80

# Start Nginx when the container starts
#CMD ["nginx", "-g", "daemon off;"]

