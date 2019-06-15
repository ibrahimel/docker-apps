#!/bin/sh

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
    docker build --pull -t code -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t code . && echo 'Done'
fi

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name code code &&

# Copy .desktop and icon files
docker cp code:/usr/share/applications/code.desktop ./ &&
docker cp code:/usr/share/code/resources/app/resources/linux/code.png ./ &&

# Remove container
docker rm --force code &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP code '$RUNTIME-v $HOME/workspace:/home/code/workspace -v $HOME/.ssh:/home/code/.ssh:ro -v $HOME/.gnupg:/home/code/.gnupg:ro -v $HOME/.gitconfig:/home/code/.gitconfig:ro'@" code.desktop &&
sed -i 's@TryExec.*@@' code.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/code/code.png@" code.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v code.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/code.desktop
