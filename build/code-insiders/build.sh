#!/bin/sh

APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t code-insiders -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t code-insiders . && echo 'Done'
fi

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name code-insiders code-insiders &&

# Copy .desktop and icon files
docker cp code-insiders:/usr/share/applications/code-insiders.desktop ./ &&
docker cp code-insiders:/usr/share/code-insiders/resources/app/resources/linux/code.png ./code-insiders.png &&

# Remove container
docker rm --force code-insiders &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP code-insiders '$RUNTIME-v $HOME/workspace:/home/code-insiders/workspace -v $HOME/.ssh:/home/code-insiders/.ssh:ro -v $HOME/.gnupg:/home/code-insiders/.gnupg:ro -v $HOME/.gitconfig:/home/code-insiders/.gitconfig:ro'@" code-insiders.desktop &&
sed -i 's@TryExec.*@@' code-insiders.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/code-insiders/code-insiders.png@" code-insiders.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v code-insiders.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/code-insiders.desktop
