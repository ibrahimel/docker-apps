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
    docker build --pull -t binaryninja -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t binaryninja . && echo 'Done'
fi

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name binaryninja binaryninja &&

# Copy .desktop and icon files
docker cp binaryninja:/opt/binaryninja/docs/img/logo.png ./binaryninja.png &&

# Remove container
docker rm --force binaryninja &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP binaryninja  $RUNTIME@" binaryninja.desktop &&
sed -i 's@TryExec.*@@' binaryninja.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/binaryninja/binaryninja.png@" binaryninja.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v binaryninja.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/binaryninja.desktop
