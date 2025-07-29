#!/bin/bash

# WordPress Multisite Initialization Script
# This script runs automatically when the WordPress container starts

set -e

echo "🚀 WordPress Multisite Initialization..."

# Wait for WordPress to be installed
wait_for_wordpress() {
    echo "⏳ Waiting for WordPress installation..."
    local max_attempts=60
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if wp core is-installed --allow-root 2>/dev/null; then
            echo "✅ WordPress is installed!"
            return 0
        fi
        
        echo "⏳ Attempt $attempt/$max_attempts - WordPress not installed yet..."
        sleep 10
        attempt=$((attempt + 1))
    done
    
    echo "❌ WordPress installation timeout"
    return 1
}

# Convert to multisite if needed
setup_multisite() {
    echo "🔍 Checking multisite status..."
    
    # Check if multisite is already enabled
    if wp core is-installed --network --allow-root 2>/dev/null; then
        echo "✅ Multisite already enabled!"
        return 0
    fi
    
    # Check if wp_blogs table exists
    if wp db query "SHOW TABLES LIKE 'wp_blogs'" --allow-root 2>/dev/null | grep -q "wp_blogs"; then
        echo "✅ Multisite tables already exist!"
        return 0
    fi
    
    echo "🔄 Converting WordPress to multisite..."
    wp core multisite-convert --allow-root
    
    echo "✅ Multisite conversion completed!"
}

# Create .htaccess file
create_htaccess() {
    echo "📝 Creating .htaccess file..."
    
    # Check if .htaccess already exists with multisite rules
    if [ -f /var/www/html/.htaccess ]; then
        if grep -q "RewriteRule.*wp-admin" /var/www/html/.htaccess; then
            echo "✅ .htaccess already has multisite rules!"
            return 0
        fi
    fi
    
    # Create .htaccess file for multisite
    cat > /var/www/html/.htaccess << 'EOF'
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
EOF
    
    chmod 644 /var/www/html/.htaccess
    echo "✅ .htaccess file created!"
}

# Main execution
echo "🚀 Starting WordPress Multisite initialization..."

# Wait for WordPress to be installed
if ! wait_for_wordpress; then
    echo "❌ WordPress initialization failed: WordPress not installed"
    exit 1
fi

# Setup multisite
if ! setup_multisite; then
    echo "❌ Multisite setup failed"
    exit 1
fi

# Create .htaccess
if ! create_htaccess; then
    echo "❌ .htaccess creation failed"
    exit 1
fi

echo "🎉 WordPress Multisite initialization complete!"
echo "🌐 Your multisite is ready!" 