#!/bin/sh

#Build Container
docker build --pull -t sublime . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name sublime sublime

# Copy .desktop and icon files
docker cp sublime:/usr/share/applications/sublime_text.desktop ./sublime.desktop
docker cp sublime:/opt/sublime_text/Icon/256x256/sublime-text.png ./sublime.png

# Remove container
docker rm --force sublime

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn sublime '-v $HOME/workspace:/home/sublime/workspace'@" sublime.desktop
sed -i 's@TryExec.*@@' sublime.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/sublime/sublime.png@" sublime.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v sublime.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/sublime.desktop
