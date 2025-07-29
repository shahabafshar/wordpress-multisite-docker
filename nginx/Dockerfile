FROM nginx:alpine

# Copy the Nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Set proper permissions
RUN chmod 644 /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80 