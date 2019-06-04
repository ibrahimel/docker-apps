#!/bin/sh

#Build Container
docker build --pull -t vlc . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name vlc vlc

# Copy .desktop and icon files
docker cp vlc:/usr/share/applications/vlc.desktop ./
docker cp vlc:/usr/share/icons/hicolor/128x128/apps/vlc.png ./

# Remove container
docker rm --force vlc

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn vlc@" vlc.desktop
sed -i 's@TryExec.*@@' vlc.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/vlc/vlc.png@" vlc.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v vlc.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/vlc.desktop
