#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t transmission -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t transmission . && echo 'Done'
fi  

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name transmission transmission &&

# Copy .desktop and icon files
docker cp transmission:/usr/share/applications/transmission-gtk.desktop ./transmission.desktop &&
docker cp transmission:/usr/share/icons/hicolor/256x256/apps/transmission.png ./ &&

# Remove container
docker rm --force transmission &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP transmission $RUNTIME@" transmission.desktop &&
sed -i 's@TryExec.*@@' transmission.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/transmission/transmission.png@" transmission.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v transmission.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/transmission.desktop
