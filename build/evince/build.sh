#!/bin/sh

APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t evince -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t evince . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name evince evince &&

# Copy .desktop and icon files
docker cp evince:/usr/share/applications/evince.desktop ./evince.desktop &&
docker cp evince:/usr/share/icons/hicolor/256x256/apps/evince.png ./evince.png &&

# Remove container
docker rm --force evince &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP evince '$RUNTIME--net=none'@" evince.desktop &&
sed -i 's@TryExec.*@@' evince.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/evince/evince.png@" evince.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v evince.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/evince.desktop
