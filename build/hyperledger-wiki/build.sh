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
    docker build --pull -t hyperledger-wiki -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t hyperledger-wiki . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP hyperledger-wiki '$RUNTIME--shm-size=2g'@" hyperledger-wiki.desktop &&
sed -i 's@TryExec.*@@' hyperledger-wiki.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/hyperledger-wiki/hyperledger-wiki.png@" hyperledger-wiki.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v hyperledger-wiki.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/hyperledger-wiki.desktop
