#!/bin/bash
set -e

# WordPress Automatic Installation and Multisite Setup
echo "🚀 WordPress Automatic Setup Starting..."

# Configuration marker to prevent re-running
MARKER_FILE="/var/www/html/.wp-setup-complete"

if [ -f "$MARKER_FILE" ]; then
    echo "✅ WordPress setup already completed"
    exit 0
fi

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
    echo "🔧 Installing WordPress..."
    
    # Install WordPress
    wp core install \
        --url="${DOMAIN_CURRENT_SITE:-localhost}" \
        --title="${WORDPRESS_TITLE:-WordPress Multisite}" \
        --admin_user="${WORDPRESS_ADMIN_USER:-admin}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD:-admin123}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL:-admin@example.com}" \
        --allow-root
    
    echo "✅ WordPress installed successfully"
fi

# Check if multisite is already enabled
if wp core is-installed --network --allow-root 2>/dev/null; then
    echo "✅ Multisite already enabled"
else
    echo "🔧 Converting to multisite..."
    
    # Add multisite constants
    wp config set MULTISITE true --raw --allow-root
    wp config set SUBDOMAIN_INSTALL "${SUBDOMAIN_INSTALL:-false}" --raw --allow-root
    wp config set DOMAIN_CURRENT_SITE "${DOMAIN_CURRENT_SITE:-localhost}" --allow-root
    wp config set PATH_CURRENT_SITE "${PATH_CURRENT_SITE:-/}" --allow-root
    wp config set SITE_ID_CURRENT_SITE "${SITE_ID_CURRENT_SITE:-1}" --raw --allow-root
    wp config set BLOG_ID_CURRENT_SITE "${BLOG_ID_CURRENT_SITE:-1}" --raw --allow-root
    
    # Convert to multisite
    wp core multisite-convert --allow-root
    
    # Create .htaccess for subdirectory multisite
    if [ "${SUBDOMAIN_INSTALL:-false}" = "false" ]; then
        cat > /var/www/html/.htaccess << 'EOF'
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
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
EOF
    fi
    
    echo "✅ Multisite conversion completed"
fi

# Create marker file to prevent re-running
touch "$MARKER_FILE"

echo "🎉 WordPress Multisite setup complete!"
echo "📍 Main site: http://${DOMAIN_CURRENT_SITE:-localhost}"
echo "🔧 Network Admin: http://${DOMAIN_CURRENT_SITE:-localhost}/wp-admin/network/"