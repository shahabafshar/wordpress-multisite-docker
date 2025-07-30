FROM wordpress:php8.4-fpm

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/php/boot-fs.php && \
    curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/php/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy custom entrypoint script and plugins
COPY docker-entrypoint-custom.sh /usr/local/bin/
COPY init-wordpress.sh /usr/local/bin/
COPY fix-mime-types.php /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint-custom.sh
RUN chmod +x /usr/local/bin/init-wordpress.sh

# Use custom entrypoint
ENTRYPOINT ["docker-entrypoint-custom.sh"]
CMD ["php-fpm"]