#!/bin/bash

# WordPress Multisite Activation Script
# Run this after WordPress is installed and accessible

set -e

echo "🚀 Converting WordPress to Multisite..."

# Load environment variables
if [ -f .env ]; then
    source .env
fi

# Get WordPress container name
CONTAINER_NAME=$(docker ps --filter "ancestor=wordpress:php8.4-fpm" --format "{{.Names}}" | head -1)

if [ -z "$CONTAINER_NAME" ]; then
    echo "❌ WordPress container not found!"
    exit 1
fi

# Check if WordPress is installed
if ! docker exec "$CONTAINER_NAME" wp core is-installed --allow-root 2>/dev/null; then
    echo "❌ WordPress not installed. Please visit your site first to complete installation."
    exit 1
fi

# Check if already multisite
if docker exec "$CONTAINER_NAME" wp core is-installed --network --allow-root 2>/dev/null; then
    echo "✅ Multisite already enabled!"
    exit 0
fi

echo "📝 Adding multisite constants..."

# Add multisite constants to wp-config.php
docker exec "$CONTAINER_NAME" wp config set MULTISITE true --raw --allow-root
docker exec "$CONTAINER_NAME" wp config set SUBDOMAIN_INSTALL "${SUBDOMAIN_INSTALL:-false}" --raw --allow-root
docker exec "$CONTAINER_NAME" wp config set DOMAIN_CURRENT_SITE "${DOMAIN_CURRENT_SITE:-localhost}" --allow-root
docker exec "$CONTAINER_NAME" wp config set PATH_CURRENT_SITE "${PATH_CURRENT_SITE:-/}" --allow-root
docker exec "$CONTAINER_NAME" wp config set SITE_ID_CURRENT_SITE "${SITE_ID_CURRENT_SITE:-1}" --raw --allow-root
docker exec "$CONTAINER_NAME" wp config set BLOG_ID_CURRENT_SITE "${BLOG_ID_CURRENT_SITE:-1}" --raw --allow-root

echo "🔧 Installing multisite network..."

# Install multisite network
docker exec "$CONTAINER_NAME" wp core multisite-install \
    --title="${WORDPRESS_TITLE:-WordPress Multisite}" \
    --allow-root

echo "📄 Creating .htaccess for multisite..."

# Create .htaccess for subdirectory multisite (default)
if [ "${SUBDOMAIN_INSTALL:-false}" = "false" ]; then
    docker exec "$CONTAINER_NAME" bash -c 'cat > /var/www/html/.htaccess << EOF
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]

# add a trailing slash to /wp-admin
RewriteRule ^([_0-9a-zA-Z-]+/)?wp-admin$ \$1wp-admin/ [R=301,L]

RewriteCond %{REQUEST_FILENAME} -f [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^ - [L]
RewriteRule ^([_0-9a-zA-Z-]+/)?(wp-(content|admin|includes).*) \$2 [L]
RewriteRule ^([_0-9a-zA-Z-]+/)?(.*\.php)$ \$2 [L]
RewriteRule . index.php [L]
EOF'
fi

echo "✅ WordPress Multisite activated successfully!"
echo ""
echo "🎉 You can now:"
echo "   • Access Network Admin: /wp-admin/network/"
echo "   • Create new sites in your network"
echo "   • Configure network-wide plugins and themes" 