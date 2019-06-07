#!/bin/sh

APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t firefox -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t firefox . && echo 'Done'
fi 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP-disposable firefox '$RUNTIME--shm-size 2g'@" firefox-disp.desktop &&
sed -i 's@TryExec.*@@' firefox-disp.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/firefox-disp/firefox-disp.png@" firefox-disp.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v firefox-disp.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/firefox-disp.desktop
