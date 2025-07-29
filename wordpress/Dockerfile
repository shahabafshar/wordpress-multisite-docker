FROM wordpress:php8.4-fpm

# Install WP-CLI if not already present
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy the initialization script
COPY init-multisite.sh /usr/local/bin/init-multisite.sh
RUN chmod +x /usr/local/bin/init-multisite.sh

# Create a startup script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["php-fpm"] 