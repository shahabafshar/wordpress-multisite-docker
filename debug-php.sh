#!/bin/bash

# Debug script for PHP-FPM connection issues

echo "🔍 Debugging PHP-FPM Connection..."

# Get container names
WORDPRESS_CONTAINER=$(docker ps --filter "ancestor=wordpress:php8.4-fpm" --format "{{.Names}}" | head -1)
NGINX_CONTAINER=$(docker ps --filter "ancestor=nginx:alpine" --format "{{.Names}}" | head -1)

if [ -z "$WORDPRESS_CONTAINER" ]; then
    echo "❌ WordPress container not found!"
    exit 1
fi

if [ -z "$NGINX_CONTAINER" ]; then
    echo "❌ Nginx container not found!"
    exit 1
fi

echo "📦 WordPress container: $WORDPRESS_CONTAINER"
echo "📦 Nginx container: $NGINX_CONTAINER"

# Check if containers are running
echo ""
echo "🔍 Checking container status..."
docker ps --filter "name=$WORDPRESS_CONTAINER" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
docker ps --filter "name=$NGINX_CONTAINER" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Check WordPress container logs
echo ""
echo "📋 WordPress container logs (last 10 lines):"
docker logs --tail 10 "$WORDPRESS_CONTAINER"

# Check Nginx container logs
echo ""
echo "📋 Nginx container logs (last 10 lines):"
docker logs --tail 10 "$NGINX_CONTAINER"

# Test PHP-FPM connection from Nginx container
echo ""
echo "🔍 Testing PHP-FPM connection..."
docker exec "$NGINX_CONTAINER" sh -c "nc -z wordpress 9000 && echo '✅ PHP-FPM connection successful' || echo '❌ PHP-FPM connection failed'"

# Check if PHP-FPM is listening
echo ""
echo "🔍 Checking PHP-FPM status..."
docker exec "$WORDPRESS_CONTAINER" sh -c "ps aux | grep php-fpm"

# Test WordPress installation
echo ""
echo "🔍 Testing WordPress installation..."
if docker exec "$WORDPRESS_CONTAINER" wp core is-installed --allow-root 2>/dev/null; then
    echo "✅ WordPress is installed"
else
    echo "ℹ️  WordPress is not installed yet"
fi

# Check Nginx configuration
echo ""
echo "🔍 Testing Nginx configuration..."
docker exec "$NGINX_CONTAINER" nginx -t

echo ""
echo "🔧 Debugging complete!"
echo "📝 If PHP-FPM connection failed, try:"
echo "   docker restart $WORDPRESS_CONTAINER"
echo "   docker restart $NGINX_CONTAINER" 