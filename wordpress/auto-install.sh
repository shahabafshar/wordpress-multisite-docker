#!/bin/bash
set -e

echo "🚀 WordPress Automatic Installation Starting..."

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
while ! wp db check --allow-root 2>/dev/null; do
    echo "Waiting for database..."
    sleep 5
done

echo "✅ Database connection established"

# Wait a bit more for stability
sleep 10

# Check if WordPress is already installed
if wp core is-installed --allow-root 2>/dev/null; then
    echo "✅ WordPress already installed"
else
    echo "🔧 Installing WordPress automatically..."
    
    # Install WordPress using environment variables
    wp core install \
        --url="${WORDPRESS_URL:-localhost}" \
        --title="${WORDPRESS_TITLE:-WordPress Multisite}" \
        --admin_user="${WORDPRESS_ADMIN_USER:-admin}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD:-admin123}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL:-admin@example.com}" \
        --allow-root
    
    echo "✅ WordPress installed successfully"
    
    # Ensure WordPress directories exist
    echo "📁 Ensuring WordPress directories exist..."
    mkdir -p /var/www/html/wp-content/themes
    mkdir -p /var/www/html/wp-content/plugins
    mkdir -p /var/www/html/wp-content/uploads
    mkdir -p /var/www/html/wp-content/mu-plugins
    
    # Ensure default theme is available
    echo "🎨 Ensuring default theme is available..."
    if [ ! -d "/var/www/html/wp-content/themes/twentytwentyfive" ]; then
        echo "📥 Installing default theme..."
        wp theme install twentytwentyfive --activate --allow-root
    fi
    
    # Also install other common themes for fallback
    if [ ! -d "/var/www/html/wp-content/themes/twentytwentyfour" ]; then
        wp theme install twentytwentyfour --allow-root 2>/dev/null || true
    fi
    
    echo "🎉 WordPress installation complete!"
    echo "🌐 Your site is ready at: ${WORDPRESS_URL:-localhost}"
    echo "👤 Admin login: ${WORDPRESS_ADMIN_USER:-admin}"
fi

# Start Apache
echo "🚀 Starting Apache..."
exec apache2-foreground 