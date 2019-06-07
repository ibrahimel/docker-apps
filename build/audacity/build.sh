#!/bin/sh

APP="docker-apps"
RUNTIME=""

if [ "$1" = "--nvidia" ] || [ "$2" = "--nvidia" ]; then
	RUNTIME="--runtime=nvidia "
    docker build --pull -t audacity -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t audacity . && echo 'Done'
fi

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name audacity audacity &&

# Copy .desktop and icon files
docker cp audacity:/usr/share/applications/audacity.desktop ./ &&
docker cp audacity:/usr/share/icons/hicolor/scalable/apps/audacity.svg ./ &&

# Remove container
docker rm --force audacity &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP audacity '$RUNTIME--net=none'@" audacity.desktop &&
sed -i 's@TryExec.*@@' audacity.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/audacity/audacity.svg@" audacity.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v audacity.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/audacity.desktop
