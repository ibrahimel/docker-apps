#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t geary -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t geary . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name geary geary &&

# Copy .desktop and icon files
docker cp geary:/usr/share/applications/geary-autostart.desktop ./geary.desktop &&
docker cp geary:/usr/share/gnome/help/geary/C/figures/geary.svg ./ &&

# Remove container
docker rm --force geary &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP geary '$RUNTIME-v $HOME/.gnupg:/home/geary/.gnupg:ro'@" geary.desktop &&
sed -i 's@TryExec.*@@' geary.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/geary/geary.svg@" geary.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v geary.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/geary.desktop
