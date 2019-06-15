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
    docker build --pull -t libreoffice -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t libreoffice . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name libreoffice libreoffice &&

# Copy .desktop and icon files
docker cp libreoffice:/usr/share/applications/libreoffice-startcenter.desktop ./libreoffice.desktop &&
docker cp libreoffice:/usr/share/icons/hicolor/128x128/apps/libreoffice-main.png ./libreoffice.png &&

# Remove container
docker rm --force libreoffice &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP libreoffice '-e LD_LIBRARY_PATH="$LD_LIBRARY_PATH=:/usr/lib/libreoffice/program:/usr/lib/x86_64-linux-gnu/" $RUNTIME'@" libreoffice.desktop &&
sed -i 's@TryExec.*@@' libreoffice.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/libreoffice/libreoffice.png@" libreoffice.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v libreoffice.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/libreoffice.desktop
