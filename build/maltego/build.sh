#!/bin/sh

#Build Container
docker build --pull -t maltego . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name maltego maltego

# Copy .desktop and icon files
docker cp maltego:/usr/share/applications/maltego.desktop ./
docker cp maltego:/usr/share/maltego/bin/maltego.ico ./maltego.ico

# Remove container
docker rm --force maltego

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn maltego@" maltego.desktop
sed -i 's@TryExec.*@@' maltego.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/maltego/maltego.ico@" maltego.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v maltego.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/maltego.desktop
