#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t whatsapp -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t whatsapp . && echo 'Done'
fi  

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name whatsapp whatsapp &&

# Copy .desktop and icon files
docker cp whatsapp:/usr/share/applications/whatsdesk.desktop ./whatsapp.desktop &&
docker cp whatsapp:/usr/share/icons/hicolor/512x512/apps/whatsdesk.png ./whatsapp.png &&

# Remove container
docker rm --force whatsapp &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP whatsapp $RUNTIME@" whatsapp.desktop &&
sed -i 's@TryExec.*@@' whatsapp.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/whatsapp/whatsapp.png@" whatsapp.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v whatsapp.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/whatsapp.desktop
