#!/bin/sh

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
    docker build --pull -t android-studio -f nvidia.Dockerfile . && echo 'Done'
else
    docker build --pull -t android-studio . && echo 'Done'
fi

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name android-studio android-studio &&

# Copy .desktop and icon files
docker cp android-studio:/opt/android-studio/bin/studio.png ./android-studio.png &&

# Remove container
docker rm --force android-studio &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP android-studio '$RUNTIME-v $HOME/workspace:/home/android-studio/workspace -v $HOME/.ssh:/home/android-studio/.ssh:ro -v $HOME/.gnupg:/home/android-studio/.gnupg:ro -v $HOME/.gitconfig:/home/android-studio/.gitconfig:ro'@" android-studio.desktop &&
sed -i 's@TryExec.*@@' android-studio.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/android-studio/android-studio.png@" android-studio.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v android-studio.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/android-studio.desktop
