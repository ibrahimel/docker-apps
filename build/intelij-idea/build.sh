#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t intelij-idea -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t intelij-idea . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name intelij-idea intelij-idea &&

# Copy .desktop and icon files
docker cp intelij-idea:/opt/idea-IC-191.7479.19/bin/idea.png ./intelij-idea.png &&

# Remove container
docker rm --force intelij-idea &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP intelij-idea '$RUNTIME-v $HOME/workspace:/home/intelij-idea/workspace -v $HOME/.ssh:/home/intelij-idea/.ssh:ro -v $HOME/.gnupg:/home/intelij-idea/.gnupg:ro -v $HOME/.gitconfig:/home/intelij-idea/.gitconfig:ro'@" intelij-idea.desktop &&
sed -i 's@TryExec.*@@' intelij-idea.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/intelij-idea/intelij-idea.png@" intelij-idea.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v intelij-idea.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/intelij-idea.desktop
