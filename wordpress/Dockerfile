FROM wordpress:latest

# Install WP-CLI for automated setup
RUN curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/php/boot-fs.php && \
    curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/php/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy automatic installation script
COPY auto-install.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/auto-install.sh

# Use custom entrypoint that runs auto-install
ENTRYPOINT ["auto-install.sh"]
CMD ["apache2-foreground"] 