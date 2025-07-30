#!/bin/bash
set -euo pipefail

# Use the original WordPress entrypoint
source /usr/local/bin/docker-entrypoint.sh

# Start the initialization script in the background
if [ "$1" = 'php-fpm' ]; then
    echo "Starting WordPress automatic setup..."
    /usr/local/bin/init-wordpress.sh &
fi

# Execute the original command
exec "$@"