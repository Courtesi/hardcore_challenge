# Hardcore Challenge Quick Start

The purpose of this repository is to automate hardcore world regeneration on player death for a multiplayer server. One particular use case for this image would be to set up a hardcore challenge for a group of friends, where if one of the friends die, then the whole server will reset.

## Installation

Install the open source container service provider [Docker](https://docs.docker.com/engine/install/).

## Features

### Versioning

You can now select the version of Minecraft you want to run with this hardcore challenge.\
Use `VERSION=(1.21.5)` to host a 1.21.5 minecraft multiplayer server.\
Use `VERSION=latest` for the latest version of minecraft.

### RCON Administration

This image includes `rcon-cli` for remote administration of the Minecraft server while it's running.

**Environment Variables:**
- `RCON_PASSWORD` - Password for RCON access (default: `minecraft`)
- `RCON_PORT` - Port for RCON (default: `25575`)

**Interactive Mode:**

Use `docker exec -it hardcore_mc rcon-cli` to open an interactive terminal:

```
> say Hello everyone!
> whitelist add PlayerName
> op AdminName
> list
> exit
```

**Single command mode:**

`docker exec hardcore_mc rcon-cli say Server restarting soon`

`docker exec hardcore_mc rcon-cli whitelist add NewPlayer`

`docker exec hardcore_mc rcon-cli op AdminUser`

## Usage

### Docker Run
To run the latest version (1.21.10), run:
```bash
docker run -d -p 25565:25565 -p 25575:25575 -v ./data:/app -e VERSION=latest -e RCON_PASSWORD=minecraft -e RCON_PORT=25575 --name hardcore_mc -it courtesi/hardcore_mc
```


**Flag Explanations:**
- `-d` - Run in detached mode (background)
- `-p 25565:25565` - Expose Minecraft server port
- `-p 25575:25575` - Expose RCON port
- `-v ./data:/app` - Mount local `./data` directory to `/app` in container for persistence
- `-e VERSION=latest` - Set Minecraft version (can be `latest` or specific like `1.21.1`)
- `-e RCON_PASSWORD=minecraft` - Set RCON password for admin access
- `-e RCON_PORT=25575` - Set RCON port (default: 25575)
- `--name hardcore_mc` - Give the container a friendly name
- `-it` - Interactive terminal (enables tty and stdin_open)
- `courtesi/hardcore_mc` - The Docker image to use

### Docker Compose
1. Create a new directory (ex: `mkdir hardcore_challenge & cd hardcore_challenge`)

2. Create a file called `docker-compose.yml` and put the contents below into it

3. Run `docker compose up -d`

4. Don't forget to port forward 25565!

```bash
services:
  hardcore_mc:
    image: courtesi/hardcore_mc
    environment:
      - VERSION=latest
      - RCON_PASSWORD=minecraft
      - RCON_PORT=25575
    volumes:
      - ./data:/app
    ports:
      - "25565:25565"
      - "25575:25575"
    tty: true
    stdin_open: true
```

### Using playit.gg
If you don't want to port forward, you can also incorporate playit.gg into this docker compose. Sign up on [playit.gg](https://playit.gg), make an account and then set up your docker agent on their website. They will give you a docker service that should like this:

```bash
  playit:
  image: ghcr.io/playit-cloud/playit-agent:0.16
  network_mode: host
  environment:
	- SECRET_KEY=...
```

Pair this `playit` service with your `hardcore_mc` service to host a hardcore multiplayer server online without port forwarding!

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

## Credit
Thanks to Bloodimooni on GitHub for providing the ```hardcore.py``` file.