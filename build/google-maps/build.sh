#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t google-maps -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t google-maps . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP google-maps '$RUNTIME--shm-size=2g'@" google-maps.desktop &&
sed -i 's@TryExec.*@@' google-maps.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/google-maps/google-maps.png@" google-maps.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v google-maps.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/google-maps.desktop
