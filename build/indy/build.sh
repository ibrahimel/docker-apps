#!/bin/sh

cp -r ../../../indy-sdk ./

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--tor" ] || [ "$2" = "--tor" ]; then
	APP="docker-apps-tor"
fi

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

sudo docker build --pull -t indy . && echo 'Done'


# Fix desktop file
#sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP indy '$RUNTIME-it'@" indy.desktop &&
#sed -i 's@TryExec.*@@' indy.desktop &&
#sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/indy/indy.png@" indy.desktop &&
#chown -R $USER:$USER ./ &&

# Add applications to user list
#cp -v indy.desktop ~/.local/share/applications/ &&
#chmod +x ~/.local/share/applications/indy.desktop
