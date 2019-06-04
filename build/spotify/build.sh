#!/bin/sh

#Build Container
docker build --pull -t spotify . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name spotify spotify

# Copy .desktop and icon files
docker cp spotify:/usr/share/spotify/spotify.desktop ./
docker cp spotify:/usr/share/spotify/icons/spotify-linux-512.png ./spotify.png

# Remove container
docker rm --force spotify

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn spotify@" spotify.desktop
sed -i 's@TryExec.*@@' spotify.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/spotify/spotify.png@" spotify.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v spotify.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/spotify.desktop
