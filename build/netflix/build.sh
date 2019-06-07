#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t netflix -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t netflix . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP netflix $RUNTIME@" netflix.desktop &&
sed -i 's@TryExec.*@@' netflix.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/netflix/netflix.png@" netflix.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v netflix.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/netflix.desktop
