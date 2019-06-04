#!/bin/sh

#Build Container
docker build --pull -t zoom-us . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name zoom-us zoom-us

# Copy .desktop and icon files
docker cp zoom-us:/usr/share/applications/Zoom.desktop ./zoom-us.desktop
docker cp zoom-us:/usr/share/pixmaps/Zoom.png ./zoom-us.png

# Remove container
docker rm --force zoom-us

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn zoom-us --runtime=nvidia@" zoom-us.desktop
sed -i 's@TryExec.*@@' zoom-us.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/zoom-us/zoom-us.png@" zoom-us.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v zoom-us.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/zoom-us.desktop
