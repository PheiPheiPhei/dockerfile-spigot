# Spigot

Dockerfile for [Spigot](https://www.spigotmc.org/) high performance
Minecraft server.

## Usage

Get started with:

    docker \
    run --rm \
    -e EULA=TRUE \
    -p 25565:25565 \
    t13a/spigot

### Configure the server

Run in specific UID/GID (default: `1000/1000`):

    docker \
    ...
    -e PUID=1001 \
    -e PGID=1002 \
    ...
    t13a/spigot

Set custom parameters:

    docker \
    ...
    -e SERVER_JVM_ARGS='--Xms512M -Xmx1024M -XX:ParallelGCThreads=1' \
    -e SERVER_ARGS='-nogui' \
    ...
    t13a/spigot

Set custom files:

    docker \
    ...
    -v $(pwd)/banned-ips.json:/spigot/banned-ips.json \
    -v $(pwd)/banned-players.json:/spigot/banned-players.json \
    -v $(pwd)/bukkit.yml:/spigot/bukkit.yml \
    -v $(pwd)/commands.yml:/spigot/commands.yml \
    -v $(pwd)/help.yml:/spigot/help.yml \
    -v $(pwd)/ops.json:/spigot/ops.json \
    -v $(pwd)/plugins:/spigot/plugins \
    -v $(pwd)/server.properties:/spigot/server.properties \
    -v $(pwd)/spigot.yml:/spigot/spigot.yml \
    -v $(pwd)/whitelist.json:/spigot/whitelist.json \
    ...
    t13a/spigot

### Backup and restore

Most users need to **create backup** periodically, and after stop.

    docker \
    ...
    -e BACKUP_AFTER_STOP=yes \
    -e BACKUP_INTERVAL_SECS=1200 \
    -e BACKUP_KEEP_NUMS=10 \
    -v $(pwd)/backup:/backup \
    ...
    t13a/spigot

Some users need to **store data in memory** like tmpfs, and restore
data before start.

    docker \
    ...
    -e RESTORE_BEFORE_START=yes \
    -v /path/to/tmpfs:/restore \
    ...
    t13a/spigot

### Suspend and resume

Stop server during no player and restart when player connected.

    docker \
    ...
    -e STOP_TIMEOUT_SECS=1200 \
    ...
    t13a/spigot

### Enable debug output

    docker \
    ...
    -e DEBUG=yes \
    ...
    t13a/spigot
