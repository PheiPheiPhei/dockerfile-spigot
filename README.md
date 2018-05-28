# Spigot

Dockerfile for [Spigot](https://www.spigotmc.org/) high performance
Minecraft server. Based on
[Arch Linux AUR package](https://aur.archlinux.org/packages/spigot/).

## Usage

Get started with:

    docker \
    run --rm \
    -e EULA=TRUE \
    -p 25565:25565 \
    t13a/spigot

To use custom configurations and plugins:

    docker \
    ...
    -v $(pwd)/banned-ips.json:/srv/craftbukkit/banned-ips.json \
    -v $(pwd)/banned-players.json:/srv/craftbukkit/banned-players.json \
    -v $(pwd)/bukkit.yml:/srv/craftbukkit/bukkit.yml \
    -v $(pwd)/commands.yml:/srv/craftbukkit/commands.yml \
    -v $(pwd)/help.yml:/srv/craftbukkit/help.yml \
    -v $(pwd)/ops.json:/srv/craftbukkit/ops.json \
    -v $(pwd)/plugins:/srv/craftbukkit/plugins \
    -v $(pwd)/server.properties:/srv/craftbukkit/server.properties \
    -v $(pwd)/spigot.yml:/srv/craftbukkit/spigot.yml \
    -v $(pwd)/whitelist.json:/srv/craftbukkit/whitelist.json \
    ...
    t13a/spigot

Most users need to **create backup** periodically and after stopped
the server.

    docker \
    ...
    -e BACKUP_AFTER_STOP=yes \
    -e BACKUP_SCHEDULE="*/15 * * * *" \
    -v $(pwd)/backup:/srv/craftbukkit/backup \
    ...
    t13a/spigot

Some users need to **store data in memory** like tmpfs, and restore
data before start.

    docker \
    ...
    -e RESTORE_DIR=/srv/craftbukkit/restore \
    -v /path/to/tmpfs:/srv/craftbukkit/restore \
    ...
    t13a/spigot

Other parameters (eg: JVM arguments, number of backups, etc) are
defined in `/etc/conf.d/spigot`. To configure it easily, pass
environment variables with `SPIGOT_` prefix.

    docker \
    ...
    -e SPIGOT_KEEP_BACKUPS="10" \
    -e SPIGOT_SERVER_START_CMD="java -Xms512M -Xmx1024M -XX:ParallelGCThreads=1 -jar './spigot.jar' nogui" \
    ...
    t13a/spigot

The notable feature "idling" introduced by Arch Linux AUR package can
**stop server during no player and restart when player connected**.

    docker \
    ...
    -e SPIGOT_IDLE_SERVER=true \
    -e SPIGOT_CHECK_PLAYER_TIME=30 \
    -e SPIGOT_IDLE_IF_TIME=1200 \
    ...
    t13a/spigot

