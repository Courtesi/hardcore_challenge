# Minecraft Hardcore Docker Container

The purpose of this repository is to automate hardcore world regeneration on player death for a multiplayer server. One particular use case for this image would be to set up a hardcore challenge for a group of friends, where if one of the friends die, then the whole server will reset.

## Installation

Install the open source container service provider [Docker](https://docs.docker.com/engine/install/).

## Features

### Versioning
	You can now select the version of Minecraft you want to run with this hardcore challenge. 
	Just include the environment variable `VERSION=(your version # here)` and the image will pull your specified version of minecraft at runtime.
	Use `VERSION=latest` for the latest version of minecraft.

### RCON Administration

  This image includes `rcon-cli` for remote administration of the Minecraft server while it's running.

  #### Configuration

  RCON is automatically enabled with configurable settings:

  **Environment Variables:**
  - `RCON_PASSWORD` - Password for RCON access (default: `minecraft`)
  - `RCON_PORT` - Port for RCON (default: `25575`)

  #### Usage

  Interactive Mode: 
  `docker exec -it hardcore_mc rcon-cli`

  This opens an interactive session where you can type commands:
  > say Hello everyone!
  > whitelist add PlayerName
  > op AdminName
  > list
  > exit

  Single Command:
  `docker exec hardcore_mc rcon-cli say Server restarting soon`
  `docker exec hardcore_mc rcon-cli whitelist add NewPlayer`
  `docker exec hardcore_mc rcon-cli op AdminUser`

## Using the image

### Docker Run
To run the latest version (1.21.10), run:
```bash
docker run -d -p 25565:25565 -v ./data:/app -e VERSION=latest --name hardcore_mc -it courtesi/hardcore_mc
```

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
      - VERSION=${VERSION:-latest}
      - RCON_PASSWORD=${RCON_PASSWORD:-minecraft}
      - RCON_PORT=${RCON_PORT:-25575}
    volumes:
      - ./data:/app
    ports:
      - "25565:25565"
      - "25575:25575"
    tty: true
    stdin_open: true
```

### Using playit.gg
You can also incorporate playit.gg into this docker compose. \
Sign up on [playit.gg](https://playit.gg), make an account and then set up your docker agent on their website. \
They will give you a docker service that should like this:

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