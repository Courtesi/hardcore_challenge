ARG BASE_IMAGE=eclipse-temurin:21-jre

FROM ${BASE_IMAGE}

# Install required tools: curl, jq, python3, bash (if missing)
RUN apt-get update && apt-get install -y curl jq python3 && rm -rf /var/lib/apt/lists/*

# Install rcon-cli
RUN RCON_CLI_VERSION=$(curl -s https://api.github.com/repos/itzg/rcon-cli/releases/latest | jq -r .tag_name) && \
    curl -L -o /tmp/rcon-cli.tar.gz https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VERSION}/rcon-cli_${RCON_CLI_VERSION}_linux_amd64.tar.gz && \
    tar -xzf /tmp/rcon-cli.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/rcon-cli && \
    rm /tmp/rcon-cli.tar.gz

# Create temp directory for scripts
RUN mkdir -p /tmp/minecraft

# Copy scripts to temp location
COPY hardcore.py /tmp/minecraft/hardcore.py
COPY download-server.sh /tmp/minecraft/download-server.sh

# Fix line endings and make download script executable
RUN sed -i 's/\r$//' /tmp/minecraft/download-server.sh && chmod +x /tmp/minecraft/download-server.sh

# Environment variables (can be overridden at runtime)
ENV VERSION=latest
ENV RCON_PASSWORD=minecraft
ENV RCON_PORT=25575

WORKDIR /app

EXPOSE 25565
EXPOSE 25575

# Entrypoint: Download server.jar, copy hardcore.py, then run it
ENTRYPOINT ["/bin/bash", "-c", "\
    /tmp/minecraft/download-server.sh && \
    cp -n /tmp/minecraft/hardcore.py /app/hardcore.py 2>/dev/null || true && \
    exec python3 /app/hardcore.py \
"]
