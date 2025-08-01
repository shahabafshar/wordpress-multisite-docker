#!/bin/bash

# WP-CLI Helper Script
# Usage: ./wp-cli.sh [command]
# Example: ./wp-cli.sh plugin list

if [ $# -eq 0 ]; then
    echo "Usage: ./wp-cli.sh [command]"
    echo "Example: ./wp-cli.sh plugin list"
    echo "Example: ./wp-cli.sh core version"
    echo "Example: ./wp-cli.sh user list"
    exit 1
fi

# Get WP-CLI container name
CONTAINER_NAME=$(docker ps --filter "name=wp-cli-init" --format "{{.Names}}" | head -1)

if [ -z "$CONTAINER_NAME" ]; then
    echo "❌ WP-CLI container not found!"
    echo "   Make sure the stack is running: docker-compose up -d"
    echo "   Note: WP-CLI container runs once during initialization"
    exit 1
fi

# Run the WP-CLI command
docker exec "$CONTAINER_NAME" wp "$@" --allow-root 