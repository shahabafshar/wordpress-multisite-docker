#!/bin/bash

# Nginx Debugging Script
# Use this to investigate Nginx configuration and logs

echo "🔍 Nginx Debugging Tools"
echo "========================"

# Get container name
CONTAINER_NAME=$(docker ps --filter "ancestor=nginx:alpine" --format "{{.Names}}" | head -1)

if [ -z "$CONTAINER_NAME" ]; then
    echo "❌ Nginx container not found!"
    exit 1
fi

echo "📦 Found Nginx container: $CONTAINER_NAME"
echo ""

echo "📋 Available commands:"
echo "1. Check Nginx configuration: docker exec $CONTAINER_NAME nginx -t"
echo "2. View Nginx logs: tail -f logs/nginx/access.log"
echo "3. View Nginx error logs: tail -f logs/nginx/error.log"
echo "4. Check Nginx config file: cat nginx/default.conf"
echo "5. Reload Nginx config: docker exec $CONTAINER_NAME nginx -s reload"
echo "6. Restart Nginx container: docker-compose restart nginx"
echo ""

echo "🔧 Testing Nginx configuration..."
docker exec "$CONTAINER_NAME" nginx -t

echo ""
echo "📊 Recent Nginx access logs:"
if [ -f "logs/nginx/access.log" ]; then
    tail -10 logs/nginx/access.log
else
    echo "No access logs found yet"
fi

echo ""
echo "🚨 Recent Nginx error logs:"
if [ -f "logs/nginx/error.log" ]; then
    tail -10 logs/nginx/error.log
else
    echo "No error logs found yet"
fi

echo ""
echo "💡 Quick fixes:"
echo "- Edit nginx/default.conf and restart: docker-compose restart nginx"
echo "- Monitor logs in real-time: tail -f logs/nginx/access.log"
echo "- Check container status: docker-compose ps" 