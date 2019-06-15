#!/bin/sh

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
    docker build --pull -t firefox -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t firefox . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name firefox firefox &&

# Copy .desktop and icon files
docker cp firefox:/usr/share/applications/firefox.desktop ./ &&
docker cp firefox:/usr/lib/firefox/browser/chrome/icons/default/default128.png ./firefox.png &&

# Remove container
docker rm --force firefox &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP firefox '$RUNTIME--shm-size 2g'@" firefox.desktop &&
sed -i 's@TryExec.*@@' firefox.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/firefox/firefox.png@" firefox.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v firefox.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/firefox.desktop
