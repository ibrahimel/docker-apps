#!/bin/sh

#Build Container
docker build --pull -t tensorflow . 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn tensorflow --runtime=nvidia@" tensorflow.desktop
sed -i 's@TryExec.*@@' tensorflow.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/tensorflow/tensorflow.png@" tensorflow.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v tensorflow.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/tensorflow.desktop
