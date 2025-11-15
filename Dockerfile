ARG BASE_IMAGE=eclipse-temurin:21-jre

FROM ${BASE_IMAGE}

# Install required tools: curl, jq, python3, bash (if missing)
RUN apt-get update && apt-get install -y curl jq python3 && rm -rf /var/lib/apt/lists/*

# Create temp directory for scripts
RUN mkdir -p /tmp/minecraft

# Copy scripts to temp location
COPY hardcore.py /tmp/minecraft/hardcore.py
COPY download-server.sh /tmp/minecraft/download-server.sh

# Make download script executable
RUN chmod +x /tmp/minecraft/download-server.sh

# Environment variable for Minecraft version (can be overridden at runtime)
ENV VERSION=latest

WORKDIR /app

EXPOSE 25565

# Entrypoint: Download server.jar, copy hardcore.py, then run it
ENTRYPOINT ["/bin/bash", "-c", "\
    /tmp/minecraft/download-server.sh && \
    cp -n /tmp/minecraft/hardcore.py /app/hardcore.py 2>/dev/null || true && \
    exec python3 /app/hardcore.py \
"]
