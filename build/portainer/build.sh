#!/bin/sh

#Build Container
docker build --pull -t portainer . 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps portainer '--user root --net=none -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data'@" portainer.desktop
sed -i 's@TryExec.*@@' portainer.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/portainer/portainer.png@" portainer.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v portainer.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/portainer.desktop
