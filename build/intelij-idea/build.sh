#!/bin/sh

#Build Container
docker build --pull -t intelij-idea . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name intelij-idea intelij-idea

# Copy .desktop and icon files
docker cp intelij-idea:/opt/idea-IC-191.7479.19/bin/idea.png ./intelij-idea.png

# Remove container
docker rm --force intelij-idea

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn intelij-idea '-v $HOME/workspace:/home/intelij-idea/workspace'@" intelij-idea.desktop
sed -i 's@TryExec.*@@' intelij-idea.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/intelij-idea/intelij-idea.png@" intelij-idea.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v intelij-idea.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/intelij-idea.desktop
