#!/bin/sh

#Build Container
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
    docker build --pull -t zoom-us -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t zoom-us . && echo 'Done'
fi  

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name zoom-us zoom-us &&

# Copy .desktop and icon files
docker cp zoom-us:/usr/share/applications/Zoom.desktop ./zoom-us.desktop &&
docker cp zoom-us:/usr/share/pixmaps/Zoom.png ./zoom-us.png &&

# Remove container
docker rm --force zoom-us &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP zoom-us '$RUNTIME--device /dev/video0'@" zoom-us.desktop &&
sed -i 's@TryExec.*@@' zoom-us.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/zoom-us/zoom-us.png@" zoom-us.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v zoom-us.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/zoom-us.desktop
