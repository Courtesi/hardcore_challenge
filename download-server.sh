#!/bin/bash

set -e

echo "Checking for Minecraft server.jar..."

# Check if server.jar exists and version matches
if [ -f /app/server.jar ] && [ -f /app/.version ] && [ "$(cat /app/.version)" = "$VERSION" ]; then
    echo "Server jar already exists for version: $(cat /app/.version)"
    exit 0
fi

echo "Downloading Minecraft server version: $VERSION"

MANIFEST_URL="https://launchermeta.mojang.com/mc/game/version_manifest.json"

# Get the version-specific manifest URL
if [ "$VERSION" = "latest" ]; then
    echo "Fetching latest release version..."
    VERSION_URL=$(curl -s "$MANIFEST_URL" | jq -r '.latest.release as $version | .versions[] | select(.id == $version) | .url')
else
    echo "Fetching version $VERSION..."
    VERSION_URL=$(curl -s "$MANIFEST_URL" | jq -r --arg ver "$VERSION" '.versions[] | select(.id == $ver) | .url')
fi

if [ -z "$VERSION_URL" ] || [ "$VERSION_URL" = "null" ]; then
    echo "Error: Could not find version $VERSION in manifest"
    exit 1
fi

# Get the server download URL
echo "Fetching server download URL..."
SERVER_URL=$(curl -s "$VERSION_URL" | jq -r '.downloads.server.url')

if [ -z "$SERVER_URL" ] || [ "$SERVER_URL" = "null" ]; then
    echo "Error: Could not find server download URL"
    exit 1
fi

# Download the server jar
echo "Downloading from: $SERVER_URL"
curl -L -o /app/server.jar "$SERVER_URL"

# Save the version for future checks
echo "$VERSION" > /app/.version

echo "Server jar downloaded successfully!"
