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
    docker build --pull -t protonmail -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t protonmail . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP protonmail '$RUNTIME--shm-size=2g'@" protonmail.desktop &&
sed -i 's@TryExec.*@@' protonmail.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/protonmail/protonmail.png@" protonmail.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v protonmail.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/protonmail.desktop
