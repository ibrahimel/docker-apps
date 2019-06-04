#!/bin/sh

#Build Container
docker build --pull -t evince . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name evince evince

# Copy .desktop and icon files
docker cp evince:/usr/share/applications/org.gnome.Evince.desktop ./evince.desktop
#docker cp evince:/usr/share/help/C/evince/figures/evincelogo.png ./evince.png

# Remove container
docker rm --force evince

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-gui evince --net=none@" evince.desktop
sed -i 's@TryExec.*@@' evince.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/evince/evince.png@" evince.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v evince.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/evince.desktop
