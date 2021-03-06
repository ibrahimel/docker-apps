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
    docker build --pull -t winds -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t winds . && echo 'Done'
fi  

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name winds winds &&

# Copy .desktop and icon files
docker cp winds:/opt/winds/winds.desktop ./ &&
docker cp winds:/opt/winds/usr/share/icons/hicolor/512x512/apps/winds.png ./ &&

# Remove container
docker rm --force winds &&


# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP winds $RUNTIME@" winds.desktop &&
sed -i 's@TryExec.*@@' winds.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/winds/winds.png@" winds.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v winds.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/winds.desktop
