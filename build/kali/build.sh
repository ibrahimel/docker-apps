#!/bin/sh

#Build Container
docker build --pull -t kali . 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn kali '-it --runtime=nvidia'@" kali.desktop
sed -i 's@TryExec.*@@' kali.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/kali/kali.png@" kali.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v kali.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/kali.desktop
