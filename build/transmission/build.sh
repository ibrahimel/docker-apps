#!/bin/sh

#Build Container
docker build --pull -t transmission . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name transmission transmission

# Copy .desktop and icon files
docker cp transmission:/usr/share/applications/transmission-gtk.desktop ./transmission.desktop
docker cp transmission:/usr/share/icons/hicolor/256x256/apps/transmission.png ./

# Remove container
docker rm --force transmission

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn transmission@" transmission.desktop
sed -i 's@TryExec.*@@' transmission.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/transmission/transmission.png@" transmission.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v transmission.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/transmission.desktop
