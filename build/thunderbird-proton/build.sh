#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t thunderbird-proton -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t thunderbird-proton . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name thunderbird-proton thunderbird-proton &&

# Copy .desktop and icon files
docker cp thunderbird-proton:/usr/share/applications/thunderbird.desktop ./thunderbird-proton.desktop &&

# Remove container
docker rm --force thunderbird-proton &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP thunderbird-proton $RUNTIME@" thunderbird-proton.desktop &&
sed -i 's@TryExec.*@@' thunderbird-proton.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/thunderbird-proton/thunderbird-proton.png@" thunderbird-proton.desktop &&
sed -i "s@Thunderbird Mail@Thunderbird ProtonMail@" thunderbird-proton.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v thunderbird-proton.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/thunderbird-proton.desktop
