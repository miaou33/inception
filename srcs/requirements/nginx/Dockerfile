# Use Alpine Linux's penultimate version as the base image.
FROM alpine:3.13

# Install Nginx
RUN apk update && \
    apk add nginx

# Create necessary folders and give permissions
RUN mkdir -p /run/nginx

# Copy over configuration files if needed
#COPY conf/default.conf /etc/nginx/http.d/default.conf

# Expose the port Nginx will run on
EXPOSE 80

# Start Nginx when the container starts
#CMD ["nginx", "-g", "daemon off;"]

