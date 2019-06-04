#!/bin/sh

#Build Container
docker build --pull -t audacity . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name audacity audacity

# Copy .desktop and icon files
docker cp audacity:/usr/share/applications/audacity.desktop ./
docker cp audacity:/usr/share/icons/hicolor/scalable/apps/audacity.svg ./

# Remove container
docker rm --force audacity

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps audacity --net=none@" audacity.desktop
sed -i 's@TryExec.*@@' audacity.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/audacity/audacity.svg@" audacity.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v audacity.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/audacity.desktop
