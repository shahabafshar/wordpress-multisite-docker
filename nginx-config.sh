#!/bin/bash

# Nginx Configuration Management Script

case "$1" in
    "view")
        echo "📄 Current Nginx Configuration:"
        echo "=================================="
        cat nginx/default.conf
        ;;
    "edit")
        echo "✏️  Opening Nginx config for editing..."
        if command -v nano >/dev/null 2>&1; then
            nano nginx/default.conf
        elif command -v vim >/dev/null 2>&1; then
            vim nginx/default.conf
        elif command -v vi >/dev/null 2>&1; then
            vi nginx/default.conf
        else
            echo "❌ No text editor found. Please edit nginx/default.conf manually."
            exit 1
        fi
        ;;
    "reload")
        echo "🔄 Reloading Nginx configuration..."
        docker-compose restart nginx
        echo "✅ Nginx reloaded!"
        ;;
    "test")
        echo "🧪 Testing Nginx configuration..."
        docker-compose exec nginx nginx -t
        ;;
    *)
        echo "🔧 Nginx Configuration Management"
        echo ""
        echo "Usage: $0 {view|edit|reload|test}"
        echo ""
        echo "Commands:"
        echo "  view   - Display current Nginx configuration"
        echo "  edit   - Open configuration in text editor"
        echo "  reload - Restart Nginx to apply changes"
        echo "  test   - Test Nginx configuration syntax"
        echo ""
        echo "Example:"
        echo "  $0 edit    # Edit the config"
        echo "  $0 reload  # Apply changes"
        ;;
esac 