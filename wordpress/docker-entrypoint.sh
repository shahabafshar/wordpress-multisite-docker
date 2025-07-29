#!/bin/bash

# Custom WordPress entrypoint with multisite initialization

# Check if multisite is already set up
if [ ! -f "/var/www/html/.multisite-configured" ]; then
    echo "🚀 Multisite not configured yet - will initialize after WordPress is ready"
    # Start initialization in background with delay
    (sleep 30 && /usr/local/bin/init-multisite.sh) &
else
    echo "✅ Multisite already configured"
fi

# Execute the original WordPress entrypoint
exec docker-entrypoint.sh "$@" 