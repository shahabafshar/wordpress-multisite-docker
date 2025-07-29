#!/bin/bash

# Custom WordPress entrypoint with multisite initialization

# Start the multisite initialization in the background
echo "🚀 Starting multisite initialization..."
/usr/local/bin/init-multisite.sh &

# Execute the original WordPress entrypoint
exec docker-entrypoint.sh "$@" 