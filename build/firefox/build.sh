#!/bin/sh

#Build Container
docker build --pull -t firefox . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name firefox firefox

# Copy .desktop and icon files
docker cp firefox:/usr/share/applications/firefox.desktop ./
docker cp firefox:/usr/lib/firefox/browser/chrome/icons/default/default128.png ./firefox.png

# Remove container
docker rm --force firefox

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn firefox '--shm-size 2g'@" firefox.desktop
sed -i 's@TryExec.*@@' firefox.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/firefox/firefox.png@" firefox.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v firefox.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/firefox.desktop
