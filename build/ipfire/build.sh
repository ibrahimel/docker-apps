#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t ipfire -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t ipfire . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP ipfire '$RUNTIME--shm-size=2g'@" ipfire.desktop &&
sed -i 's@TryExec.*@@' ipfire.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/ipfire/ipfire.png@" ipfire.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v ipfire.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/ipfire.desktop
