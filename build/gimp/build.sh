#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t gimp -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t gimp . && echo 'Done'
fi 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name gimp gimp &&

# Copy .desktop and icon files
docker cp gimp:/usr/share/applications/gimp.desktop ./ &&
docker cp gimp:/usr/share/icons/hicolor/256x256/apps/gimp.png ./ &&

# Remove container
docker rm --force gimp &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP gimp '$RUNTIME--net=none'@" gimp.desktop &&
sed -i 's@TryExec.*@@' gimp.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/gimp/gimp.png@" gimp.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v gimp.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/gimp.desktop
