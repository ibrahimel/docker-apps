#!/bin/sh

#Build Container
docker build --pull -t qbittorrent . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name qbittorrent qbittorrent

# Copy .desktop and icon files
docker cp qbittorrent:/usr/share/applications/qbittorrent.desktop ./
docker cp qbittorrent:/usr/share/icons/hicolor/192x192/apps/qbittorrent.png ./

# Remove container
docker rm --force qbittorrent

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn qbittorrent@" qbittorrent.desktop
sed -i 's@TryExec.*@@' qbittorrent.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/qbittorrent/qbittorrent.png@" qbittorrent.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v qbittorrent.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/qbittorrent.desktop
