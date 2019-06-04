#!/bin/sh

#Build Container
docker build --pull -t discord . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name discord discord

# Copy .desktop and icon files
docker cp discord:/usr/share/discord/discord.desktop ./
docker cp discord:/usr/share/discord/discord.png ./

# Remove container
docker rm --force discord

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn discord@" discord.desktop
sed -i 's@TryExec.*@@' discord.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/discord/discord.png@" discord.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v discord.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/discord.desktop
