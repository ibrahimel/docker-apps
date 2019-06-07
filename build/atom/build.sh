#!/bin/sh

APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t atom -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t atom . && echo 'Done'
fi

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name atom atom &&

# Copy .desktop and icon files
docker cp atom:/usr/share/applications/atom.desktop ./ &&
docker cp atom:/usr/share/atom/atom.png ./ &&

# Remove container
docker rm --force atom &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP atom '$RUNTIME-v $HOME/workspace:/home/atom/workspace -v $HOME/.ssh:/home/atom/.ssh:ro -v $HOME/.gnupg:/home/atom/.gnupg:ro -v $HOME/.gitconfig:/home/atom/.gitconfig:ro'@" atom.desktop &&
sed -i 's@TryExec.*@@' atom.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/atom/atom.png@" atom.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v atom.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/atom.desktop
