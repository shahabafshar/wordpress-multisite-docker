#!/bin/bash

# WordPress Multisite Setup Script
# This script converts a single-site WordPress installation to multisite

set -e

echo "🚀 Starting WordPress Multisite Setup..."

# Check if we're in a Docker environment
if [ -f /.dockerenv ]; then
    echo "📦 Running inside Docker container"
    WP_PATH="/var/www/html"
else
    echo "🖥️  Running on host system"
    WP_PATH="./wordpress"
fi

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
until wp db check --path="$WP_PATH" --allow-root; do
    echo "Database not ready yet, waiting..."
    sleep 2
done

echo "✅ Database is ready!"

# Check if WordPress is already installed
if ! wp core is-installed --path="$WP_PATH" --allow-root; then
    echo "❌ WordPress is not installed. Please install WordPress first."
    echo "   You can access http://your-domain:8080 to run the WordPress installer."
    exit 1
fi

echo "✅ WordPress is installed"

# Check if multisite is already enabled
if wp core is-installed --network --path="$WP_PATH" --allow-root; then
    echo "✅ Multisite is already enabled!"
    exit 0
fi

echo "🔄 Converting WordPress to multisite..."

# Convert to multisite
wp core multisite-convert --path="$WP_PATH" --allow-root

echo "✅ WordPress converted to multisite!"

# Create .htaccess file for multisite
echo "📝 Creating .htaccess file for multisite..."

cat > "$WP_PATH/.htaccess" << 'EOF'
# BEGIN WordPress
# The directives (lines) between "BEGIN WordPress" and "END WordPress" are
# dynamically generated, and should only be modified via WordPress filters.
# Any changes to the directives between these markers will be overwritten.
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOF

echo "✅ .htaccess file created!"

# Set proper permissions
chmod 644 "$WP_PATH/.htaccess"

echo "🎉 Multisite setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Access your WordPress site at http://your-domain:8080"
echo "2. Log in to the WordPress admin"
echo "3. Go to My Sites > Network Admin > Sites to manage your multisite"
echo "4. Create additional sites as needed"
echo ""
echo "🔧 If you need to create additional sites, use:"
echo "   wp site create --slug=newsite --title='New Site' --path='$WP_PATH' --allow-root" 