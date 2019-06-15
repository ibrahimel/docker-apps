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
    docker build --pull -t tor-browser -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t tor-browser . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name tor-browser tor-browser &&

# Copy .desktop and icon files
docker cp tor-browser:/usr/local/bin/start-tor-browser.desktop ./tor-browser.desktop &&

# Remove container
docker rm --force tor-browser &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP-disposable tor-browser $RUNTIME@" tor-browser.desktop &&
sed -i 's@Name.*@Name=Tor Browser@' tor-browser.desktop &&
sed -i 's@TryExec.*@@' tor-browser.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/tor-browser/tor-browser.ico@" tor-browser.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v tor-browser.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/tor-browser.desktop
