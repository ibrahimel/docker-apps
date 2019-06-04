#!/bin/sh

#Build Container
docker build --pull -t winds . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name winds winds

# Copy .desktop and icon files
docker cp winds:/opt/winds/winds.desktop ./
docker cp winds:/opt/winds/winds.png ./

# Remove container
docker rm --force winds


# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn winds@" winds.desktop
sed -i 's@TryExec.*@@' winds.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/winds/winds.png@" winds.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v winds.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/winds.desktop
