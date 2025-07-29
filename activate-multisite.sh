#!/bin/bash

# WordPress Multisite Activation Script
# Run this after completing the initial WordPress setup

echo "🚀 WordPress Multisite Activation"

# Get container name
CONTAINER_NAME=$(docker ps --filter "ancestor=wordpress:php8.4-fpm" --format "{{.Names}}" | head -1)

if [ -z "$CONTAINER_NAME" ]; then
    echo "❌ WordPress container not found!"
    exit 1
fi

echo "📦 Found WordPress container: $CONTAINER_NAME"

# Check if WordPress is installed
echo "🔍 Checking WordPress installation..."
if ! docker exec "$CONTAINER_NAME" wp core is-installed --allow-root 2>/dev/null; then
    echo "❌ WordPress is not installed. Please complete the WordPress installation first."
    echo "📝 Visit http://your-domain:8080 to complete the installation."
    exit 1
fi

echo "✅ WordPress is installed"

# Check if multisite is already enabled
echo "🔍 Checking multisite status..."
if docker exec "$CONTAINER_NAME" wp core is-installed --network --allow-root 2>/dev/null; then
    echo "✅ Multisite is already enabled!"
    exit 0
fi

echo "🔄 Converting WordPress to multisite..."

# Convert to multisite
if docker exec "$CONTAINER_NAME" wp core multisite-convert --allow-root; then
    echo "✅ Multisite conversion successful!"
else
    echo "❌ Multisite conversion failed!"
    exit 1
fi

# Create .htaccess file
echo "📝 Creating .htaccess file..."
docker exec "$CONTAINER_NAME" bash -c 'cat > /var/www/html/.htaccess << "EOF"
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]

# add a trailing slash to /wp-admin
RewriteRule ^([_0-9a-zA-Z-]+/)?wp-admin$ $1wp-admin/ [R=301,L]

RewriteCond %{REQUEST_FILENAME} -f [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^ - [L]
RewriteRule ^([_0-9a-zA-Z-]+/)?(wp-(content|admin|includes).*) $2 [L]
RewriteRule ^([_0-9a-zA-Z-]+/)?(.*\.php)$ $2 [L]
RewriteRule . index.php [L]
EOF'

echo "✅ .htaccess file created!"

# Set permissions
docker exec "$CONTAINER_NAME" chmod 644 /var/www/html/.htaccess

echo "🎉 WordPress Multisite activation complete!"
echo "🌐 Your multisite is now ready at http://your-domain:8080"
echo "📝 Access Network Admin at http://your-domain:8080/wp-admin/network/" 