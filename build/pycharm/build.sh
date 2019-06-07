#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t pycharm -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t pycharm . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name pycharm pycharm &&

# Copy .desktop and icon files
docker cp pycharm:/opt/pycharm-community-2019.1.3/bin/pycharm.png ./pycharm.png &&

# Remove container
docker rm --force pycharm &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP pycharm '$RUNTIME-v $HOME/workspace:/home/pycharm/workspace'@" pycharm.desktop &&
sed -i 's@TryExec.*@@' pycharm.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/pycharm/pycharm.png@" pycharm.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v pycharm.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/pycharm.desktop
