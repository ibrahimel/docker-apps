#!/bin/sh

#Build Container
docker build --pull -t code . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name code code

# Copy .desktop and icon files
docker cp code:/usr/share/applications/code.desktop ./
docker cp code:/usr/share/code/resources/app/resources/linux/code.png ./

# Remove container
docker rm --force code

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn code '-v $HOME/workspace:/home/code/workspace'@" code.desktop
sed -i 's@TryExec.*@@' code.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/code/code.png@" code.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v code.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/code.desktop
