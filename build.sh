#!/bin/bash
set -e

# Build script for Campfire Home Assistant Add-on

echo "Building Campfire Home Assistant Add-on..."

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not available"
    exit 1
fi

# Build the add-on for local testing
echo "Building for local architecture..."
docker build \
    --build-arg BUILD_FROM="homeassistant/amd64-base:latest" \
    -t local/addon-campfire:latest \
    ./campfire/

echo "Build completed successfully!"
echo ""
echo "To test the add-on locally, you can run:"
echo "docker run -p 3000:3000 -e CAMPFIRE_DOMAIN=localhost local/addon-campfire:latest"