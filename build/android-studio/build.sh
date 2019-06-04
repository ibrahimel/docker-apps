#!/bin/sh

#Build Container
docker build --pull -t android-studio . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name android-studio android-studio

# Copy .desktop and icon files
docker cp android-studio:/opt/android-studio/bin/studio.png ./android-studio.png

# Remove container
docker rm --force android-studio

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn android-studio '-v $HOME/workspace:/home/android-studio/workspace'@" android-studio.desktop
sed -i 's@TryExec.*@@' android-studio.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/android-studio/android-studio.png@" android-studio.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v android-studio.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/android-studio.desktop
