#!/bin/bash

# Test Nginx Configuration Script

echo "🔍 Testing Nginx Configuration"
echo "================================"

# Check if nginx/default.conf exists
if [ ! -f "nginx/default.conf" ]; then
    echo "❌ nginx/default.conf not found!"
    echo "Creating basic Nginx configuration..."
    
    mkdir -p nginx
    cat > nginx/default.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    root /var/www/html;
    index index.php index.html index.htm;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 256;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/json;

    # WordPress rewrite rules
    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    # PHP handling
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_read_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_connect_timeout 300;
    }

    # Static files
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
    echo "✅ Created nginx/default.conf"
fi

# Check if logs directory exists
if [ ! -d "logs/nginx" ]; then
    echo "📁 Creating logs directory..."
    mkdir -p logs/nginx
    echo "✅ Created logs/nginx directory"
fi

# Check if containers are running
echo ""
echo "🔍 Checking container status..."
if docker-compose ps | grep -q "Up"; then
    echo "✅ Containers are running"
    
    # Get Nginx container name
    NGINX_CONTAINER=$(docker-compose ps -q nginx)
    if [ -n "$NGINX_CONTAINER" ]; then
        echo "📦 Nginx container: $NGINX_CONTAINER"
        
        # Test Nginx configuration
        echo ""
        echo "🔧 Testing Nginx configuration..."
        if docker exec "$NGINX_CONTAINER" nginx -t; then
            echo "✅ Nginx configuration is valid"
        else
            echo "❌ Nginx configuration has errors"
        fi
        
        # Check if config file exists in container
        echo ""
        echo "📄 Checking if config file exists in container..."
        if docker exec "$NGINX_CONTAINER" test -f /etc/nginx/conf.d/default.conf; then
            echo "✅ /etc/nginx/conf.d/default.conf exists in container"
        else
            echo "❌ /etc/nginx/conf.d/default.conf not found in container"
        fi
    fi
else
    echo "❌ No containers are running"
    echo "Start containers with: docker-compose up -d"
fi

echo ""
echo "💡 Next steps:"
echo "1. If containers aren't running: docker-compose up -d"
echo "2. If config is invalid: Edit nginx/default.conf and restart nginx"
echo "3. Check logs: docker-compose logs nginx" 