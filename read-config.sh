#!/bin/bash

# Simple script to read Nginx configuration

echo "📄 Nginx Configuration File"
echo "============================"
echo ""

if [ -f "nginx/default.conf" ]; then
    echo "✅ File exists: nginx/default.conf"
    echo ""
    echo "📋 Configuration content:"
    echo "------------------------"
    cat nginx/default.conf
else
    echo "❌ File not found: nginx/default.conf"
    echo ""
    echo "💡 To create the file:"
    echo "   mkdir -p nginx"
    echo "   nano nginx/default.conf"
fi

echo ""
echo "🔧 Quick commands:"
echo "   cat nginx/default.conf          # View config"
echo "   nano nginx/default.conf         # Edit config"
echo "   docker-compose restart nginx    # Apply changes" 