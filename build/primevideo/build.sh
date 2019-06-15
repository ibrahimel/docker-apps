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
    docker build --pull -t primevideo -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t primevideo . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP primevideo '$RUNTIME--shm-size=2g'@" primevideo.desktop &&
sed -i 's@TryExec.*@@' primevideo.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/primevideo/primevideo.png@" primevideo.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v primevideo.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/primevideo.desktop
