#!/bin/bash

# Fix WordPress Multisite Issues
# This script fixes common multisite problems like redirect loops and 404 errors

echo "🔧 Fixing WordPress Multisite Issues..."

# Get the container name
CONTAINER_NAME=$(docker ps --filter "ancestor=wordpress:latest" --format "{{.Names}}" | head -n 1)

if [ -z "$CONTAINER_NAME" ]; then
    echo "❌ WordPress container not found!"
    exit 1
fi

echo "📦 Found WordPress container: $CONTAINER_NAME"

# Fix domain configuration
echo "🌐 Fixing domain configuration..."
docker exec -u 33:33 $CONTAINER_NAME wp option update home "https://dashplan.io" --allow-root
docker exec -u 33:33 $CONTAINER_NAME wp option update siteurl "https://dashplan.io" --allow-root

# Update multisite constants
echo "⚙️  Updating multisite constants..."
docker exec -u 33:33 $CONTAINER_NAME wp config set WP_ALLOW_MULTISITE true --raw --allow-root
docker exec -u 33:33 $CONTAINER_NAME wp config set MULTISITE true --raw --allow-root
docker exec -u 33:33 $CONTAINER_NAME wp config set SUBDOMAIN_INSTALL false --raw --allow-root
docker exec -u 33:33 $CONTAINER_NAME wp config set DOMAIN_CURRENT_SITE "dashplan.io" --allow-root
docker exec -u 33:33 $CONTAINER_NAME wp config set PATH_CURRENT_SITE "/" --allow-root
docker exec -u 33:33 $CONTAINER_NAME wp config set SITE_ID_CURRENT_SITE 1 --raw --allow-root
docker exec -u 33:33 $CONTAINER_NAME wp config set BLOG_ID_CURRENT_SITE 1 --raw --allow-root

# Regenerate .htaccess
echo "📄 Regenerating .htaccess..."
docker exec -u 33:33 $CONTAINER_NAME wp rewrite flush --hard --allow-root

# Clear cache
echo "🧹 Clearing cache..."
docker exec -u 33:33 $CONTAINER_NAME wp cache flush --allow-root

echo "✅ Multisite issues fixed!"
echo ""
echo "🔗 You can now access:"
echo "   Main site: https://dashplan.io"
echo "   Network admin: https://dashplan.io/wp-admin/network/"
echo "   Subsite admin: https://dashplan.io/test/wp-admin/"
echo ""
echo "💡 If you still have issues, try:"
echo "   1. Clear your browser cache"
echo "   2. Delete browser cookies for dashplan.io"
echo "   3. Restart the WordPress container" 