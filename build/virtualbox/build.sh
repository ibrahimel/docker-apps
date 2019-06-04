#!/bin/sh

#Build Container
docker build --pull -t virtualbox . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name virtualbox virtualbox

#Postbuild stuff
sudo docker cp virtualbox:/usr/lib/virtualbox /usr/lib
sudo docker cp virtualbox:/usr/share/virtualbox /usr/share
sudo /usr/lib/virtualbox/vboxdrv.sh setup
sudo rm -rf /usr/share/virtualbox /usr/lib/virtualbox

# Copy .desktop and icon files
docker cp virtualbox:/usr/share/applications/virtualbox.desktop ./
docker cp virtualbox:/usr/share/icons/hicolor/128x128/apps/virtualbox.png ./

# Remove container
docker rm --force virtualbox

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn virtualbox --privileged@" virtualbox.desktop
sed -i 's@TryExec.*@@' virtualbox.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/virtualbox/virtualbox.png@" virtualbox.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v virtualbox.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/virtualbox.desktop
