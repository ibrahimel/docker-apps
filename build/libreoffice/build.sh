#!/bin/sh

#Build Container
docker build --pull -t libreoffice . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name libreoffice libreoffice

# Copy .desktop and icon files
docker cp libreoffice:/usr/share/applications/libreoffice-startcenter.desktop ./libreoffice.desktop
docker cp libreoffice:/usr/share/icons/hicolor/128x128/apps/libreoffice-main.png ./libreoffice.png

# Remove container
docker rm --force libreoffice

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps libreoffice --net=none@" libreoffice.desktop
sed -i 's@TryExec.*@@' libreoffice.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/libreoffice/libreoffice.png@" libreoffice.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v libreoffice.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/libreoffice.desktop
