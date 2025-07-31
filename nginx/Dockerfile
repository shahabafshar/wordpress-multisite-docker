FROM nginx:alpine

# Copy the Nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Set proper permissions
RUN chmod 644 /etc/nginx/conf.d/default.conf

# Disable envsubst processing to prevent variable substitution errors
RUN rm -f /docker-entrypoint.d/20-envsubst-on-templates.sh

# Expose port 80
EXPOSE 80 