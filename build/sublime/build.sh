#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--tor" ] || [ "$2" = "--tor" ]; then
	APP="docker-apps-tor"
fi

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t sublime -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t sublime . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name sublime sublime &&

# Copy .desktop and icon files
docker cp sublime:/usr/share/applications/sublime_text.desktop ./sublime.desktop &&
docker cp sublime:/opt/sublime_text/Icon/256x256/sublime-text.png ./sublime.png &&

# Remove container
docker rm --force sublime &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP sublime '$RUNTIME-v $HOME/workspace:/home/sublime/workspace'@" sublime.desktop &&
sed -i 's@TryExec.*@@' sublime.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/sublime/sublime.png@" sublime.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v sublime.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/sublime.desktop
