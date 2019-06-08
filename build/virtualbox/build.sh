#!/bin/sh

#Build Container
APP="docker-apps"
RUNTIME=""

if [ "$1" = "--vpn" ] || [ "$2" = "--vpn" ]; then
	APP="docker-apps-vpn"
fi

docker build --pull -t virtualbox . && echo 'Done'

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name virtualbox virtualbox &&

#Postbuild stuff
sudo docker cp virtualbox:/usr/lib/virtualbox /usr/lib &&
sudo docker cp virtualbox:/usr/share/virtualbox /usr/share &&
# Copy .desktop and icon files
docker cp virtualbox:/usr/share/applications/virtualbox.desktop ./ &&
docker cp virtualbox:/usr/share/icons/hicolor/64x64/apps/virtualbox.png ./ &&

# Remove container
docker rm --force virtualbox &&

sudo /usr/lib/virtualbox/vboxdrv.sh setup &&
sudo rm -rf /usr/share/virtualbox /usr/lib/virtualbox &&

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/$APP virtualbox '$RUNTIME--privileged'@" virtualbox.desktop &&
sed -i 's@TryExec.*@@' virtualbox.desktop &&
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/virtualbox/virtualbox.png@" virtualbox.desktop &&
chown -R $USER:$USER ./ &&

# Add applications to user list
cp -v virtualbox.desktop ~/.local/share/applications/ &&
chmod +x ~/.local/share/applications/virtualbox.desktop
