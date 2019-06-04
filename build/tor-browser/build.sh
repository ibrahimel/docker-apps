#!/bin/sh

#Build Container
docker build --pull -t tor-browser . 

#Run in background for file copy
docker run --rm -it -d --entrypoint=bash --name tor-browser tor-browser

# Copy .desktop and icon files
docker cp tor-browser:/usr/local/bin/start-tor-browser.desktop ./tor-browser.desktop
#docker cp tor-browser:/usr/local/bin/Browser/browser/chrome/icons/default/default128.png ./tor-browser.png

# Remove container
docker rm --force tor-browser

# Fix desktop file
sed -i "s@Exec.*@Exec=$HOME/.docker-apps/bin/docker-apps-vpn-disposable tor-browser@" tor-browser.desktop
sed -i 's@Name.*@Name=Tor Browser@' tor-browser.desktop
sed -i 's@TryExec.*@@' tor-browser.desktop
sed -i "s@Icon.*@Icon=$HOME/.docker-apps/build/tor-browser/tor-browser.ico@" tor-browser.desktop
chown -R $USER:$USER ./

# Add applications to user list
cp -v tor-browser.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/tor-browser.desktop
