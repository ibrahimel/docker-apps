#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t typora -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t typora . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name typora typora &&

# Copy .desktop and icon files
docker cp typora:/usr/share/applications/typora.desktop ./typora.desktop &&
docker cp typora:/usr/share/icons/hicolor/256x256/apps/typora.png ./ &&

# Remove container
docker rm --force typora &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP typora '$RUNTIME--net=none -v $HOME/workspace:/home/typora/workspace'@" typora.desktop &&
sed -i 's@TryExec.*@@' typora.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/typora/typora.png@" typora.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v typora.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/typora.desktop
