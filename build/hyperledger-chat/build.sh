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
    docker build --pull -t hyperledger-chat -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t hyperledger-chat . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP hyperledger-chat '$RUNTIME--shm-size=2g'@" hyperledger-chat.desktop &&
sed -i 's@TryExec.*@@' hyperledger-chat.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/hyperledger-chat/hyperledger-chat.png@" hyperledger-chat.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v hyperledger-chat.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/hyperledger-chat.desktop
