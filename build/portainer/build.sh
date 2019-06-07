#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t portainer -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t portainer . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP portainer '$RUNTIME--net=none --user root -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data'@" portainer.desktop &&
sed -i 's@TryExec.*@@' portainer.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/portainer/portainer.png@" portainer.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v portainer.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/portainer.desktop
