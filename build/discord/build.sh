#!/bin/sh

APP="docker-apps"
RUNTIME=""

if [ "$1" = "--tor" ] || [ "$2" = "--tor" ]; then
	APP="docker-apps-tor"
fi

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t discord -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t discord . && echo 'Done'
fi

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name discord discord &&

# Copy .desktop and icon files
docker cp discord:/usr/share/discord/discord.desktop ./ &&
docker cp discord:/usr/share/discord/discord.png ./ &&

# Remove container
docker rm --force discord &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP discord $RUNTIME@" discord.desktop &&
sed -i 's@TryExec.*@@' discord.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/discord/discord.png@" discord.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v discord.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/discord.desktop
