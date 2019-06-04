#!/bin/sh

#Build Container
docker build --pull -t pycharm . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name pycharm pycharm

# Copy .desktop and icon files
docker cp pycharm:/opt/pycharm-community-2019.1.3/bin/pycharm.png ./pycharm.png

# Remove container
docker rm --force pycharm

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn pycharm '-v $HOME/workspace:/home/pycharm/workspace'@" pycharm.desktop
sed -i 's@TryExec.*@@' pycharm.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/pycharm/pycharm.png@" pycharm.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v pycharm.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/pycharm.desktop
