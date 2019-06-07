#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t qbittorrent -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t qbittorrent . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name qbittorrent qbittorrent &&

# Copy .desktop and icon files
docker cp qbittorrent:/usr/share/applications/qbittorrent.desktop ./ &&
docker cp qbittorrent:/usr/share/icons/hicolor/192x192/apps/qbittorrent.png ./ &&

# Remove container
docker rm --force qbittorrent &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP qbittorrent $RUNTIME@" qbittorrent.desktop &&
sed -i 's@TryExec.*@@' qbittorrent.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/qbittorrent/qbittorrent.png@" qbittorrent.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v qbittorrent.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/qbittorrent.desktop
