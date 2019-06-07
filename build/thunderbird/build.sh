#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t thunderbird -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t thunderbird . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name thunderbird thunderbird &&

# Copy .desktop and icon files
docker cp thunderbird:/usr/share/applications/thunderbird.desktop ./ &&
docker cp thunderbird:/usr/lib/thunderbird/chrome/icons/default/default128.png ./thunderbird.png &&

# Remove container
docker rm --force thunderbird &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP thunderbird $RUNTIME@" thunderbird.desktop &&
sed -i 's@TryExec.*@@' thunderbird.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/thunderbird/thunderbird.png@" thunderbird.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v thunderbird.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/thunderbird.desktop
