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

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP whatsapp '$RUNTIME--shm-size=2g'@" whatsapp.desktop &&
sed -i 's@TryExec.*@@' whatsapp.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/whatsapp/whatsapp.png@" whatsapp.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v whatsapp.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/whatsapp.desktop
