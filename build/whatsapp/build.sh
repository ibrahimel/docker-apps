#!/bin/sh

#Build Container
docker build --pull -t whatsapp . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name whatsapp whatsapp

# Copy .desktop and icon files
docker cp whatsapp:/usr/share/applications/whatsdesk.desktop ./whatsapp.desktop
docker cp whatsapp:/usr/share/icons/hicolor/512x512/apps/whatsdesk.png ./whatsapp.png

# Remove container
docker rm --force whatsapp

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn whatsapp@" whatsapp.desktop
sed -i 's@TryExec.*@@' whatsapp.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/whatsapp/whatsapp.png@" whatsapp.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v whatsapp.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/whatsapp.desktop
