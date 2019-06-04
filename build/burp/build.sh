#!/bin/sh

#Build Container
docker build --pull -t burp . 

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn burp@" burp.desktop
sed -i 's@TryExec.*@@' burp.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/burp/burp.png@" burp.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v burp.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/burp.desktop
