#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t kali -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t kali . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP kali '$RUNTIME-it'@" kali.desktop &&
sed -i 's@TryExec.*@@' kali.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/kali/kali.png@" kali.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v kali.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/kali.desktop
