#!/bin/sh

#Build Container
docker build --pull -t telegram . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name telegram telegram

# Copy .desktop and icon files
docker cp telegram:/usr/share/applications/telegramdesktop.desktop ./telegram.desktop
docker cp telegram:/usr/share/icons/hicolor/512x512/apps/telegram.png ./telegram.png

# Remove container
docker rm --force telegram

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn telegram@" telegram.desktop
sed -i 's@TryExec.*@@' telegram.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/telegram/telegram.png@" telegram.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v telegram.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/telegram.desktop
