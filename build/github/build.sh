#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t github -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t github . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP github '$RUNTIME--shm-size=2g'@" github.desktop &&
sed -i 's@TryExec.*@@' github.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/github/github.png@" github.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v github.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/github.desktop
