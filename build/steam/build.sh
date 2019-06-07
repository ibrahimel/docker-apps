#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t steam -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t steam . && echo 'Done'
fi

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name steam steam &&

# Copy .desktop and icon files
docker cp steam:/usr/share/applications/steam.desktop ./ &&
docker cp steam:/usr/share/icons/hicolor/256x256/apps/steam.png ./ &&

# Remove container
docker rm --force steam &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP steam  '$RUNTIME--shm-size 2g'@" steam.desktop &&
sed -i 's@TryExec.*@@' steam.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/steam/steam.png@" steam.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v steam.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/steam.desktop
