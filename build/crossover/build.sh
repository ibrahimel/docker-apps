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
    docker build --pull -t crossover -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t crossover . && echo 'Done'
fi

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name crossover crossover &&

# Copy .desktop and icon files
docker cp crossover:/opt/cxoffice/share/icons/128x128/crossover.png ./ &&

# Remove container
docker rm --force crossover &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP crossover  '$RUNTIME--shm-size 2g'@" crossover.desktop &&
sed -i 's@TryExec.*@@' crossover.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/crossover/crossover.png@" crossover.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v crossover.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/crossover.desktop
