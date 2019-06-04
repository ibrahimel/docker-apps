#!/bin/sh

#Build Container
docker build -t thunderbird . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name thunderbird thunderbird

# Copy .desktop and icon files
docker cp thunderbird:/usr/share/applications/thunderbird.desktop ./
docker cp thunderbird:/usr/share/thunderbird/chrome/icons/default/default256.png ./thunderbird.png

# Remove container
docker rm --force thunderbird

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn thunderbird@" thunderbird.desktop
sed -i 's@TryExec.*@@' thunderbird.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/thunderbird/thunderbird.png@" thunderbird.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v thunderbird.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/thunderbird.desktop
