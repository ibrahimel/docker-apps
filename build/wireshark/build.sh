#!/bin/sh

#Build Container
docker build --pull -t wireshark . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name wireshark wireshark

# Copy .desktop and icon files
docker cp wireshark:/usr/share/applications/wireshark.desktop ./
docker cp wireshark:/usr/share/icons/hicolor/256x256/apps/wireshark.png ./

# Remove container
docker rm --force wireshark

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps wireshark '--privileged --net=host'@" wireshark.desktop
sed -i 's@TryExec.*@@' wireshark.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/wireshark/wireshark.png@" wireshark.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v wireshark.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/wireshark.desktop
