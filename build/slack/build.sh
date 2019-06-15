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
    docker build --pull -t slack -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t slack . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name slack slack &&

# Copy .desktop and icon files
docker cp slack:/usr/share/applications/slack.desktop ./ &&
docker cp slack:/usr/share/pixmaps/slack.png ./ &&

# Remove container
docker rm --force slack &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP slack $RUNTIME@" slack.desktop &&
sed -i 's@TryExec.*@@' slack.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/slack/slack.png@" slack.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v slack.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/slack.desktop
