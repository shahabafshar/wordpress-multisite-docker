#!/bin/bash

# WordPress Automatic Installation Script
# This script runs inside the WP-CLI container

set -e

echo "⏳ Waiting for database and WordPress to be ready..."
sleep 15

echo "🔍 Checking if WordPress is already installed..."
if wp core is-installed --allow-root 2>/dev/null; then
    echo "✅ WordPress is already installed!"
    exit 0
fi

echo "📝 Installing WordPress..."

# Install WordPress
wp core install \
    --url="${DOMAIN_CURRENT_SITE:-localhost:8080}" \
    --title="${WORDPRESS_TITLE:-WordPress Multisite}" \
    --admin_user="${WORDPRESS_ADMIN_USER:-admin}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD:-admin123}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL:-admin@example.com}" \
    --skip-email \
    --allow-root

echo "🔧 Configuring WordPress..."

# Set site URL
wp option update home "http://${DOMAIN_CURRENT_SITE:-localhost:8080}" --allow-root
wp option update siteurl "http://${DOMAIN_CURRENT_SITE:-localhost:8080}" --allow-root

# Set timezone
wp option update timezone_string "UTC" --allow-root

# Set date format
wp option update date_format "F j, Y" --allow-root

# Set time format
wp option update time_format "g:i a" --allow-root

# Set permalink structure
wp rewrite structure "/%postname%/" --allow-root

# Flush rewrite rules
wp rewrite flush --allow-root

echo "✅ WordPress installed and configured successfully!"
echo ""
echo "🎉 Your WordPress site is ready:"
echo "   • URL: http://${DOMAIN_CURRENT_SITE:-localhost:8080}"
echo "   • Admin: http://${DOMAIN_CURRENT_SITE:-localhost:8080}/wp-admin/"
echo "   • Username: ${WORDPRESS_ADMIN_USER:-admin}"
echo "   • Password: ${WORDPRESS_ADMIN_PASSWORD:-admin123}" 