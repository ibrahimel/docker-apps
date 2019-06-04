#!/bin/sh

#Build Container
docker build --pull -t atom . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name atom atom

# Copy .desktop and icon files
docker cp atom:/usr/share/applications/atom.desktop ./
docker cp atom:/usr/share/atom/atom.png ./

# Remove container
docker rm --force atom

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn atom '-v $HOME/workspace:/home/atom/workspace'@" atom.desktop
sed -i 's@TryExec.*@@' atom.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/atom/atom.png@" atom.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v atom.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/atom.desktop
